require 'parslet'

module Travis
  module Conditions
    class Parser < Parslet::Parser
      root :expr_or

      rule :expr_or  do
        spaced(expr_and.as(:lft), op_or, expr_or.as(:rgt)).as(:or) | expr_and
      end

      rule :expr_and do
        spaced(expr_inner.as(:lft), op_and, expr_and.as(:rgt)).as(:and) | expr_inner
      end

      rule :expr_inner do
        parens(expr_or) | ts(expr_incl | expr_is | expr_cmp)
      end

      rule :expr_cmp do
        spaced(name.as(:lft), op_cmp.as(:op), value.as(:rgt)).as(:cmp)
      end

      rule :expr_incl do
        spaced(name.as(:lft), op_incl, parens(list).as(:rgt)).as(:incl)
      end

      rule :expr_is do
        spaced(name.as(:lft), op_is, presence.as(:rgt)).as(:is)
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

      rule :presence do
        (stri('present') | stri('blank')).as(:str)
      end

      rule :op_is do
        stri('is')
      end

      rule :op_cmp do
        str('=~') | str('=')
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

      def stri(str)
        str(str) | str(str.upcase)
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

      rule is: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:is, lft[:str].to_s, rgt[:str].to_s.downcase.to_sym]
      end
    end
  end
end
