module Travis
  module Conditions
    module V0
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

        def split(str)
          str.split('=', 2)
        end

        def symbolize(value)
          case value
          when Hash
            value.map { |key, value| [key.to_sym, symbolize(value)] }.to_h
          when Array
            value.map { |value| symbolize(value) }
          else
            value
          end
        end

        def normalize(data)
          data = symbolize(data)
          data[:env] = normalize_env(data[:env])
          data
        end

        def normalize_env(env)
          symbolize(to_h(env || {}))
        rescue ::ArgumentError
          raise ArgumentError, "Cannot normalize data[:env] (#{env.inspect} given)"
        end

        def to_h(obj)
          case obj
          when Hash
            obj
          else
            Array(obj).map { |obj| split(obj.to_s) }.to_h
          end
        end
      end
    end
  end
end
