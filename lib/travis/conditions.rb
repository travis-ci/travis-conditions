require 'travis/conditions/v0'
require 'travis/conditions/v1'

module Travis
  module Conditions
    ParseError = Class.new(StandardError)

    class << self
      def eval(str, data, opts = {})
        const(opts).eval(str, data)
      end

      def parse(str, opts = {})
        const(opts).parse(str, opts)
      end

      def const(opts)
        opts[:version] == :v0 ? V0 : V1
      end
    end
  end
end
