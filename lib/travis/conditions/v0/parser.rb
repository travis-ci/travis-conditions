require 'parslet'

module Travis
  module Conditions
    module V0
      class Parser < Struct.new(:opts) # rubocop:disable Metrics/ClassLength
        FUNCS    = %w[env].freeze
        PRESENCE = %w[present blank].freeze

        def parse(str)
          parser.parse(str)
        end

        private

        def parser
          @parser ||= define_parser(opts[:keys]).new
        end

        def define_parser(keywords) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          Class.new(Parslet::Parser) do
            root :expr_or

            rule :expr_or do
              spaced(expr_and.as(:lft), op_or, expr_or.as(:rgt)).as(:or) | expr_and
            end

            rule :expr_and do
              spaced(expr_inner.as(:lft), op_and, expr_and.as(:rgt)).as(:and) | expr_inner
            end

            rule :expr_inner do
              lnot(parens(expr_or) | expr_incl | expr_is | expr_regex | expr_cmp)
            end

            rule :expr_cmp do
              spaced(lhs.as(:lft), op_cmp.as(:op), value.as(:rgt)).as(:cmp)
            end

            rule :expr_regex do
              spaced(lhs.as(:lft), op_regex.as(:op), regex.as(:rgt)).as(:cmp)
            end

            rule :expr_incl do
              spaced(lhs.as(:lft), op_incl, parens(list).as(:rgt)).as(:incl)
            end

            rule :expr_is do
              spaced(lhs.as(:lft), op_is, presence.as(:rgt)).as(:is)
            end

            def lnot(node)
              (stri('not').maybe >> space >> node.as(:rgt)).as(:not) | node
            end

            rule :list do
              (value >> (ts(str(',')) >> value).repeat)
            end

            rule :lhs do
              func | keyword
            end

            rule :keyword do
              stris(*keywords)
            end

            rule :func do
              (stris(*FUNCS).as(:name) >> parens(word)).as(:func)
            end

            rule :word do
              match('[\w_\-]').repeat(1).as(:str)
            end

            rule :regex do
              quoted('/') | match('[\S]').repeat(1).as(:str)
            end

            rule :value do
              unquoted | quoted('"') | quoted("'")
            end

            rule :unquoted do
              match('[^\s\"\'\(\),]').repeat(1).as(:str)
            end

            def quoted(chr)
              str(chr) >> match("[^#{chr}]").repeat.as(:str) >> str(chr)
            end

            rule :presence do
              stris(*PRESENCE).as(:str)
            end

            rule :op_is do
              stri('is')
            end

            rule :op_cmp do
              str('=') | str('!=')
            end

            rule :op_regex do
              str('=~') | str('!~')
            end

            rule :op_incl do
              stri('in')
            end

            rule :op_or do
              stri('or')
            end

            rule :op_and do
              stri('and')
            end

            rule :space do
              match('\s').repeat(1)
            end

            rule :space? do
              space.maybe
            end

            def stris(*strs)
              strs.inject(stri(strs.shift)) { |node, str| node | stri(str) }
            end

            def stri(str)
              str(str.to_s) | str(str.to_s.upcase)
            end

            def parens?(node)
              spaced?(str('(').maybe, node, str(')').maybe)
            end

            def parens(node)
              spaced?(str('('), node, str(')'))
            end

            def spaced?(*nodes)
              nodes.zip([space?] * nodes.size).flatten[0..-2].inject(&:>>)
            end

            def spaced(*nodes)
              # nodes.zip([space] * nodes.size).flatten[0..-2].inject(&:>>)
              nodes.zip([space?] * nodes.size).flatten[0..-2].inject(&:>>)
            end

            def ls(node)
              space? >> node
            end

            def ts(node)
              node >> space?
            end
          end
        end
      end

      class Transform < Parslet::Transform
        OP = {
          '=' => :eq,
          '!=' => :not_eq,
          '=~' => :match,
          '!~' => :not_match
        }.freeze

        str  = ->(node) { node.is_a?(Hash) ? node[:str].to_s : node.to_s }
        sym  = ->(node) { str.call(node).downcase.to_sym }
        func = ->(node) { [sym.call(node[:func][:name]), str.call(node[:func])] }
        list = ->(node) { node.is_a?(Array) ? node.map { |v| str.call(v) } : [str.call(node)] }
        lhs  = ->(node) { node.is_a?(Hash) && node.key?(:func) ? func.call(node) : str.call(node) }

        rule not: { rgt: subtree(:rgt) } do
          [:not, rgt]
        end

        rule or: { lft: subtree(:lft), rgt: subtree(:rgt) } do
          [:or, lft, rgt]
        end

        rule and: { lft: subtree(:lft), rgt: subtree(:rgt) } do
          [:and, lft, rgt]
        end

        rule cmp: { op: simple(:op), lft: subtree(:lft), rgt: subtree(:rgt) } do
          [OP[op.to_s], lhs.call(lft), str.call(rgt)]
        end

        rule incl: { lft: subtree(:lft), rgt: subtree(:rgt) } do
          [:in, lhs.call(lft), list.call(rgt)]
        end

        rule is: { lft: subtree(:lft), rgt: subtree(:rgt) } do
          [:is, lhs.call(lft), sym.call(rgt)]
        end
      end
    end
  end
end
