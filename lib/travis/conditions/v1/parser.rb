require 'strscan'
require 'forwardable'
require 'travis/conditions/v1/boolean'
require 'travis/conditions/v1/helper'

# var  = 'type'
#      | 'repo'
#      | 'head_repo'
#      | 'os'
#      | 'dist'
#      | 'group'
#      | 'sudo'
#      | 'language'
#      | 'sender'
#      | 'fork'
#      | 'branch'
#      | 'head_branch'
#      | 'tag'
#      | 'commit_message';
#
# func = 'env' || 'concat';
# pred = 'present' | 'blank';
#
# eq   = '=' | '==' | '!=';
# re   = '=~' | '~=` | '!~';
# in   = 'in' | 'not in' | 'IN' | 'NOT IN';
# is   = 'is' | 'is not' | 'IS' | 'IS NOT';
# or   = 'or' | 'OR' | '||';
# and  = 'and' | 'AND' | '&&';
#
# list = oprd | oprd ',' list;
# call = func '(' list ')';
# val  = word | quoted;
#
# oprd = var | val | call;
#
# term = oprd is pred
#      | oprd in '(' list ')'
#      | oprd re regx
#      | oprd eq oprd
#      | oprd;
#
# expr = expr or expr
#      | expr and expr
#      | not expr
#      | '(' expr ')'
#      | term

module Travis
  module Conditions
    module V1
      class Parser
        extend Forwardable
        include Boolean, Helper

        VAR   = /type|repo|head_repo|os|dist|group|sudo|language|sender|fork|
                 branch|head_branch|tag|commit_message/x

        PRED  = /present|blank|true|false/i
        FUNC  = /env|concat/i
        IN    = /in|not in/i
        IS    = /is not|is/i
        EQ    = /==|=/
        NEQ   = /!=/
        RE    = /=~|~=/
        NRE   = /!~/
        COMMA = /,/
        WORD  = /[^\s\(\)"',=!]+/
        CONT  = /\\\s*[\n\r]/

        OP = {
          '='   => :eq,
          '=='  => :eq,
          '!='  => :not_eq,
          '=~'  => :match,
          '~='  => :match,
          '!~'  => :not_match
        }

        MSGS = {
          invalid:     'Invalid condition: %p',
          parse_error: 'Could not parse %s',
          shell_var:   'Variable names cannot start with a dollar (shell code does not work). If you are trying to compare to an env var, please use env("name")',
          shell_str:   'Strings cannot start with a dollar (shell code does not work). This can be bypassed by quoting the string.'
        }

        def_delegators :str, :rest, :scan, :skip, :string, :pos, :peek
        attr_reader :str

        def initialize(str)
          raise ArgumentError, MSGS[:invalid] % [str] unless str.is_a?(String)
          @str = StringScanner.new(filter(str))
        end

        def filter(str)
          str.gsub(CONT, ' ')
        end

        def parse
          res = expr
          error(:parse_error, string.inspect) unless res && !str.rest?
          res
        end

        def term
          lft = operand
          lst = in_list(lft) and return lst
          prd = is_pred(lft) and return prd
          op  = re and return [op, lft, regex]
          op  = eq and return [op, lft, operand]
          lft
        end

        def operand
          op = space { var || call || val }
          op or err('an operand')
        end

        def regex
          val = call
          return [:reg, val] if val
          return unless reg = space { Regex.new(rest).scan }
          str.pos = str.pos + reg.size
          [:reg, reg.gsub(%r(^/|/$), '')] # or err('an operand')
        end

        def eq
          op = space { scan(EQ) || scan(NEQ) } and OP[op]
        end

        def re
          op = space { scan(RE) || scan(NRE) } and OP[op]
        end

        def var
          pos = str.pos
          var = scan(VAR)
          error(:shell_var) if var && var[0] == '$'
          return [:var, var.downcase.to_sym] if var && boundary?
          str.pos = pos
          nil
        end

        BOUND = /[\s,=)|]/

        def boundary?
          peek(1) =~ BOUND || str.eos?
        end

        def call
          return unless name = func
          args = parens { list }
          args or return
          return [:call, name.to_sym, args]
        end

        def val
          val = quoted || word and [:val, val]
        end

        def is_pred(term)
          op = is or return
          pr = pred or return
          [op.downcase.sub(' ', '_').to_sym, term, pr.downcase.to_sym]
        end

        def in_list(term)
          op = self.in or return
          list = parens { list! }
          [op.downcase.sub(' ', '_').to_sym, term, list]
        end

        def list!
          list.tap { |list| err 'a list of values' if list.empty? }
        end

        def list
          return [] unless item = var || call || val
          list = comma ? [item] + self.list : [item]
          skip(COMMA)
          list.compact
        end

        def func
          space { scan(FUNC) }
        end

        def pred
          space { scan(PRED)&.to_sym }
        end

        def word
          str = space { scan(WORD) }
          error(:shell_str) if str && str[0] == '$'
          str
        end

        def in
          space { scan(IN) }
        end

        def is
          space { scan(IS) }
        end

        def comma
          space { scan(COMMA) }
        end

        def error(key, *vals)
          raise ParseError, MSGS[key] % vals
        end
      end
    end
  end
end
