require 'travis/conditions/v0'
require 'travis/conditions/v1'

module Travis
  module Conditions
    ParseError = Class.new(StandardError)

    class << self
      def eval(str, data, opts = {})
        const = opts[:version] == :v0 ? V0 : V1
        const.eval(str, data)
      end
    end
  end
end
