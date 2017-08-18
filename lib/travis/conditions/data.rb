module Travis
  module Conditions
    class Data < Struct.new(:data)
      MSGS = {
        keys:   'Data must be a symbolized Hash.',
        values: 'Data must be a Hash holding Strings.'
      }

      def initialize(data)
        super
        validate
      end

      def [](key)
        data[key.to_sym]
      end

      private

        def validate
          msgs = []
          msgs << :keys   unless hash? && symbolized?
          msgs << :values unless strings?
          error(msgs) if msgs.any?
        end

        def error(msgs)
          raise ArgumentError, msgs.map { |key| MSGS[key] }.join(' ')
        end

        def hash?
          data.is_a?(Hash)
        end

        def symbolized?
          data.keys.all? { |key| key.is_a?(Symbol) }
        end

        def strings?
          !hash? || data.values.all? { |key| key.is_a?(String) }
        end
    end
  end
end
