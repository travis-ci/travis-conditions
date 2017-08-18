require 'parslet'

module Travis
  module Conditions
    class Parser < Parslet::Parser
      root :expr_or

      rule :expr_or  do
        (expr_and.as(:lft) >> op_or >> expr_or.as(:rgt)).as(:or) | expr_and
      end

      rule :expr_and do
        (expr_inner.as(:lft) >> op_and >> expr_and.as(:rgt)).as(:and) | expr_inner
      end

      rule :expr_inner do
        parens(expr_or) | (expr_cmp | expr_incl) >> space?
      end

      rule :expr_cmp do
        spaced(name.as(:lft), op_cmp.as(:op), value.as(:rgt)).as(:cmp)
      end

      rule :expr_incl do
        spaced(name.as(:lft), op_incl, parens(list).as(:rgt)).as(:incl)
      end

      rule :list do
        (value >> (ts(str(',')) >> value).repeat)
      end

      rule :name do
        match('[\w_\-]').repeat(1).as(:str)
      end

      rule :value do
        unquoted | double_quoted | single_quoted
      end

      rule :unquoted do
        match('[^\s\"\'\(\),]').repeat(1).as(:str)
      end

      rule :double_quoted do
        str('"') >> match('[^"]').repeat.as(:str) >> str('"')
      end

      rule :single_quoted do
        str("'") >> match("[^']").repeat.as(:str) >> str("'")
      end

      rule :op_cmp do
        str('=~') | str('=')
      end

      rule :op_incl do
        str('IN') | str('in')
      end

      rule :op_or do
        ts(str('OR') | str('or'))
      end

      rule :op_and do
        ts(str('AND') | str('and'))
      end

      rule :space do
        match('\s').repeat(1)
      end

      rule :space? do
        space.maybe
      end

      def parens(node)
        spaced(ts(str('(')), node, ts(str(')')))
      end

      def spaced(*nodes)
        nodes.zip([space?] * nodes.size).flatten[0..-2].inject(&:>>)
      end

      def ts(node)
        node >> space?
      end
    end

    class Transform < Parslet::Transform
      OP = {
        '='  => :eq,
        '=~' => :match,
      }

      rule or: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:or, lft, rgt]
      end

      rule and: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:and, lft, rgt]
      end

      rule cmp: { op: simple(:op), lft: subtree(:lft), rgt: subtree(:rgt) } do
        [OP[op.to_s], lft[:str].to_s, rgt[:str].to_s]
      end

      rule incl: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        list = rgt.is_a?(Array) ? rgt.map { |v| v[:str].to_s } : [rgt[:str].to_s]
        [:in, lft[:str].to_s, list]
      end
    end
  end
end
