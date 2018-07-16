module Travis
  module Conditions
    module V1
      class Data < Struct.new(:data)
        PAIRS = /((?:\\.|[^= ]+)*)=("(?:\\.|[^"\\]+)*"|(?:\\.|[^ "\\]+)*)/
        QUOTE = /^(["'])(.*)\1$/

        def initialize(data)
          super(normalize(data))
        end

        def [](key)
          data[key.to_sym]
        end

        def env(key)
          data.fetch(:env, {})[key.to_sym]
        end

        private

          def symbolize(obj)
            case obj
            when Hash
              obj.map { |key, value| [key&.to_sym, symbolize(value)] }.to_h
            when Array
              obj.map { |obj| symbolize(obj) }
            else
              obj
            end
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

          def normalize(data)
            data = symbolize(data)
            data[:env] = normalize_env(data[:env])
            data
          end

          def normalize_env(env)
            symbolize(to_h(env || {}))
          rescue TypeError
            raise arg_error(env)
          end

          def to_h(obj)
            case obj
            when Hash
              obj
            else
              Array(obj).map { |obj| parse(obj.to_s) }.flatten(1).to_h
            end
          end

          def parse(str)
            str = str.strip
            raise arg_error(str) if str.empty? || !str.include?("=")
            str.scan(PAIRS).map { |lft, rgt| [lft, cast(unquote(rgt))] }
          end

          def unquote(str)
            QUOTE =~ str && $2 || str
          end

          def arg_error(arg)
            ArgumentError.new("Invalid env data (#{arg.inspect} given)")
          end
      end
    end
  end
end
