require 'travis/conditions/data'
require 'travis/conditions/eval'
require 'travis/conditions/parser'

module Travis
  module Conditions
    class << self
      def eval(str, data)
        Eval.new(parse(str, keys: data.keys), Data.new(data)).apply
      end

      def parse(str, opts = {})
        tree = parser(opts).parse(str)
        Transform.new.apply(tree)
      end

      def parser(opts)
        parsers[opts] ||= Parser.new(opts)
      end

      def parsers
        @parsers ||= {}
      end
    end
  end
end