require 'travis/conditions/data'
require 'travis/conditions/eval'
require 'travis/conditions/parser'

module Travis
  module Conditions
    class << self
      def eval(str, data)
        Eval.new(parse(str), Data.new(data)).apply
      end

      def parse(str)
        tree = Parser.new.parse(str)
        Transform.new.apply(tree)
      end
    end
  end
end
