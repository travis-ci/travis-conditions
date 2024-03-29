module Travis
  module Conditions
    module V1
      class Eval < Struct.new(:sexp, :data)
        def apply
          !!evl(sexp)
        end

        private

        def evl(expr)
          expr = send(*expr) if expr.is_a?(Array)
          cast(expr)
        end

        def not(lft)
          !evl(lft)
        end

        def or(lft, rgt)
          evl(lft) || evl(rgt)
        end

        def and(lft, rgt)
          evl(lft) && evl(rgt)
        end

        def eq(lft, rgt)
          evl(lft) == evl(rgt)
        end

        def not_eq(lft, rgt)
          !eq(lft, rgt)
        end


        def match(lft, rgt)
          lft, rgt = evl(lft), evl(rgt)
          lft = lft&.to_s
          lft && rgt && (lft =~ rgt || rgt =~ lft)
        end

        def not_match(lft, rgt)
          !match(lft, rgt)
        end

        def in(lft, rgt)
          rgt = rgt.map { |val| evl(val) }
          rgt.include?(evl(lft))
        end

        def not_in(lft, rgt)
          !evl([:in, lft, rgt])
        end

        def is(lft, rgt)
          send(rgt, evl(lft))
        end

        def is_not(lft, rgt)
          !evl([:is, lft, rgt])
        end

        def val(str)
          str
        end

        def reg(expr)
          str = evl(expr)
          Regexp.new(str) if str
        rescue RegexpError
          raise ArgumentError, "Invalid regular expression: /#{str}/"
        end

        def var(name)
          data[name]
        end

        def call(name, args)
          send(name.to_s.downcase, *args.map { |arg| evl(arg) })
        end

        def env(key = nil)
          data.env(key)
        end

        def concat(*args)
          args.inject('') { |str, arg| str + arg.to_s }
        end

        def present(value)
          value.respond_to?(:empty?) ? !value.empty? : !!value
        end

        def blank(value)
          !present(value)
        end

        def true(value)
          !!value
        end

        def false(value)
          !value
        end

        def cast(obj)
          case obj.to_s.downcase
          when 'false'
            false
          when 'true'
            true
          else
            obj
          end
        end
      end
    end
  end
end
