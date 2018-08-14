require 'strscan'
require 'forwardable'

module Travis
  module Conditions
    module V1
      class Regex
        REGEX = %r(\S*[^\s\)]+)
        DELIM = '/'
        ESC   = '\\'

        extend Forwardable

        def_delegators :str, :check, :eos?, :getch, :peek, :pos, :scan, :skip, :string
        attr_reader :str

        def initialize(str)
          @str = StringScanner.new(str.to_s.strip)
          @esc = false
        end

        def scan
          word || regex
        end

        def word
          return if peek(1) == DELIM
          str.scan(REGEX)
        end

        def regex
          return unless peek(1) == DELIM && reg = getch
          char = nil
          reg << char while (char = read) && char != :eos
          reg << DELIM if char == :eos
          reg unless reg.empty?
        end

        def read
          char = peek(1)
          if char == DELIM && !@esc
            :eos
          elsif char == ESC
            @esc = true
            getch
          else
            @esc = false
            getch
          end
        end
      end
    end
  end
end
