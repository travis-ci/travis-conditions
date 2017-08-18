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

        def is(lft, rgt)
          send(rgt, lft)
        end

        def present(value)
          value.respond_to?(:empty?) && !value.empty?
        end

        def blank(value)
          !present(value)
        end
    end
  end
end
