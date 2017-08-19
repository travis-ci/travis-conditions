module Travis
  module Conditions
    class Data < Struct.new(:data)
      def initialize(data)
        super(symbolize(data))
      end

      def [](key)
        data[key.to_sym]
      end

      def env(key)
        data.fetch(:env, {})[key.to_sym]
      end

      private

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
