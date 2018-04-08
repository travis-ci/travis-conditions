# https://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
#
# term = 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
#
# not  = 'not' | 'NOT';
# and  = 'and' | 'AND';
# or   = 'or'  | 'OR';
#
# expr = expr or expr
#      | expr and expr
#      | not expr
#      | '(' expr ')'
#      | var

# E --> T {( "or" ) T}
# T --> P {( "and" ) P}
# P --> v | "(" E ")" | "NOT" E

# expr = exp2 { or exp2 }
# exp2 = oprd { and oprd }
# oprd = term | '(' expr ')' | not expr

module Travis
  module Conditions
    module V1
      module Boolean
        NOT   = /not/i
        AND   = /and/i
        OR    = /or/i

        BOP = {
          'or'  => :or,
          'and' => :and,
          'not' => :not
        }

        def expr
          lft = expr_
          lft = [:or, lft, expr_] while op(OR)
          lft
        end

        def expr_
          lft = oprd
          lft = [:and, lft, oprd] while op(AND)
          lft
        end

        def oprd
          t = parens { expr } and return t
          t = not_ { oprd } and return t
          term
        end

        def not_
          pos = self.pos
          space { scan(NOT) } or return
          t = yield and return [:not, t]
          str.pos = pos
          nil
        end

        def op(op)
          op = space { scan(op) } and BOP[op.downcase]
        end
      end
    end
  end
end
