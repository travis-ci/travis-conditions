require 'parslet'

module Travis
  module Conditions
    class Parser < Parslet::Parser
      FUNCS    = ['env']
      PRESENCE = ['present', 'blank']

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
        spaced(var.as(:lft), op_cmp.as(:op), value.as(:rgt)).as(:cmp)
      end

      rule :expr_incl do
        spaced(var.as(:lft), op_incl, parens(list).as(:rgt)).as(:incl)
      end

      rule :expr_is do
        spaced(var.as(:lft), op_is, presence.as(:rgt)).as(:is)
      end

      rule :list do
        (value >> (ts(str(',')) >> value).repeat)
      end

      rule :var do
        func | word
      end

      rule :word do
        match('[\w_\-]').repeat(1).as(:str)
      end

      rule :func do
        (stris(*FUNCS).as(:name) >> parens(word)).as(:func)
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
        (stris(*PRESENCE)).as(:str)
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

      def stris(*strs)
        strs.inject(stri(strs.shift)) { |node, str| node | stri(str) }
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

      str  = ->(node) { node.is_a?(Hash) ? node[:str].to_s : node.to_s }
      sym  = ->(node) { str.(node).downcase.to_sym }
      func = ->(node) { [sym.(node[:func][:name]), str.(node[:func])] }
      list = ->(node) { node.is_a?(Array) ? node.map { |v| str.(v) } : [str.(node)] }
      var  = ->(node) { node.key?(:func) ? func.(node) : str.(node) }

      rule or: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:or, lft, rgt]
      end

      rule and: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:and, lft, rgt]
      end

      rule cmp: { op: simple(:op), lft: subtree(:lft), rgt: subtree(:rgt) } do
        [OP[op.to_s], var.(lft), str.(rgt)]
      end

      rule incl: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:in, var.(lft), list.(rgt)]
      end

      rule is: { lft: subtree(:lft), rgt: subtree(:rgt) } do
        [:is, var.(lft), sym.(rgt)]
      end
    end
  end
end
