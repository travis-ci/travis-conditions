# this is going to be extracted to a separate gem

require 'strscan'
require 'forwardable'

module Travis
  module EnvVars
    class String
      ParseError = Class.new(ArgumentError)

      KEY   = /[^\s=]+/
      WORD  = /(\\["']|[^'"\s])+/
      QUOTE = /(['"]{1})/
      SPACE = /\s+/
      EQUAL = /=/

      extend Forwardable

      def_delegators :str, :eos?, :peek, :pos, :scan, :skip, :string
      attr_reader :str

      def initialize(str)
        @str = StringScanner.new(str)
      end

      def to_h
        pairs.to_h
      end

      def parse
        join(pairs).tap { err('end of string') unless eos? }
      end

      def join(pairs)
        pairs.map { |pair| pair.join('=') }
      end

      def pairs
        pairs = [pair]
        pairs += self.pairs while space
        pairs
      end

      def pair
        return unless key = self.key
        parts = [key, equal, value]
        [parts.first, parts.last]
      end

      def key
        scan(KEY)
      end

      def equal
        scan(EQUAL) || err('=')
      end

      def value
        quoted || word
      end

      def word
        scan(WORD)
      end

      def quoted
        return unless peek(1) =~ QUOTE
        scan(/#{$1}(\\#{$1}|[^#{$1}])*#{$1}/)
      end

      def space
        scan(SPACE)
      end

      def err(char)
        raise ParseError, "expected #{char} at position #{pos} in: #{string.inspect}"
      end
    end
  end
end
