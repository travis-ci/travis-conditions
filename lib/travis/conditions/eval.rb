module Travis
  module Conditions
    class Eval < Struct.new(:sexp, :data)
      def apply
        !!evl(sexp)
      end

      private

        def evl(value)
          case value
          when Array
            send(*value)
          else
            data[value]
          end
        end

        def or(lft, rgt)
          evl(lft) || evl(rgt)
        end

        def and(lft, rgt)
          evl(lft) && evl(rgt)
        end

        def eq(lft, rgt)
          evl(lft) == rgt
        end

        def match(lft, rgt)
          evl(lft) =~ Regexp.new(rgt)
        end

        def in(lft, rgt)
          rgt.include?(evl(lft))
        end

        def is(lft, rgt)
          send(rgt, evl(lft))
        end

        def env(key)
          data.env(key)
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
