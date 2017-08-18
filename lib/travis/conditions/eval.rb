module Travis
  module Conditions
    class Eval < Struct.new(:sexp, :data)
      def apply
        evl(sexp)
      end

      private

        def evl(value)
          !!send(*value)
        end

        def or(lft, rgt)
          evl(lft) || evl(rgt)
        end

        def and(lft, rgt)
          evl(lft) && evl(rgt)
        end

        def eq(lft, rgt)
          data[lft] == rgt
        end

        def match(lft, rgt)
          data[lft] =~ Regexp.new(rgt)
        end

        def in(lft, rgt)
          rgt.include?(data[lft])
        end
    end
  end
end
