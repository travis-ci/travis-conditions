module Travis
  module Conditions
    module V1
      class Data < Struct.new(:data)
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
            raise ArgumentError.new("Cannot normalize data[:env] (#{env.inspect} given)")
          end

          def to_h(obj)
            case obj
            when Hash
              obj
            else
              Array(obj).map { |obj| split(obj.to_s) }.to_h
            end
          end

          def split(str)
            return if str.strip.empty?
            lft, rgt = str.split('=', 2)
            [lft, cast(rgt)]
          end
      end
    end
  end
end
