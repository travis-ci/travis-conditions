require 'travis/conditions/data'
require 'travis/conditions/eval'
require 'travis/conditions/parser'
require 'travis/conditions/v1'

module Travis
  module Conditions
    ParseError = Class.new(StandardError)

    class << self
      def eval(str, data, opts = {})
        return V1.eval(str, data) if opts[:v1]
        Eval.new(parse(str, keys: data.keys), Data.new(data)).apply
      end

      def parse(str, opts = {})
        tree = parser(opts).parse(str)
        Transform.new.apply(tree)
      rescue Parslet::ParseFailed
        raise ParseError
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
