module Travis
  module Conditions
    class Data < Struct.new(:data)
      def initialize(data)
        data = symbolize(data)
        data[:env] = symbolize(to_h(data[:env] || {}))
        super(data)
      end

      def [](key)
        data[key.to_sym]
      end

      def env(key)
        data.fetch(:env, {})[key.to_sym]
      end

      private

        def to_h(obj)
          case obj
          when Hash
            obj
          else
            Array(obj).map { |value| split(value.to_s) }.to_h
          end
        end

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
    end
  end
end
