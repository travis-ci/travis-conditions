module Travis
  module Conditions
    module V1
      module Helper
        QUOTE = /["']{1}/
        OPEN  = /\(/
        CLOSE = /\)/
        SPACE = /\s*/

        def quoted
          return unless quote = scan(QUOTE)

          scan(/[^#{quote}]*/).tap { scan(/#{quote}/) || err(quote) }
        end

        def parens(&)
          space { skip(OPEN) } and space(&).tap { skip(CLOSE) || err(')') }
        end

        def space
          skip(SPACE)
          yield.tap { skip(SPACE) }
        end

        def err(char)
          raise ParseError, "expected #{char} at position #{pos} in: #{string.inspect}"
        end
      end
    end
  end
end
