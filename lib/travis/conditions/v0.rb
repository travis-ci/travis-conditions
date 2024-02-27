require 'travis/conditions/v0/data'
require 'travis/conditions/v0/eval'
require 'travis/conditions/v0/parser'

module Travis
  module Conditions
    module V0
      class << self
        def eval(str, data, _opts = {})
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
end
