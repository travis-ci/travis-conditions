require 'travis/conditions/v0'
require 'travis/conditions/v1'

module Travis
  module Conditions
    Error = Class.new(::ArgumentError)
    ArgumentError = Class.new(Error)
    ParseError = Class.new(Error)

    class << self
      def eval(str, data, opts = {})
        const(opts).eval(str, data)
      end

      def parse(str, opts = {})
        const(opts).parse(str, opts)
      end

      def const(opts)
        opts[:version] == :v1 ? V1 : V0
      end
    end
  end
end
