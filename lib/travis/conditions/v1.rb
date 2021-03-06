require 'travis/conditions/v1/data'
require 'travis/conditions/v1/eval'
require 'travis/conditions/v1/parser'
require 'travis/conditions/v1/regex'

module Travis
  module Conditions
    module V1
      class << self
        def eval(str, data)
          Eval.new(parse(str), Data.new(data)).apply
        end

        def parse(str, _ = nil)
          Parser.new(str).parse
        end
      end
    end
  end
end
