require 'sh_vars'

module Travis
  module Conditions
    module V1
      class Data < Struct.new(:data)
        def initialize(data)
          super(normalize(data))
        end

        def [](key)
          data[key&.to_sym]
        end

        def env(key)
          value = data.fetch(:env, {})[key&.to_sym]
          value = value.gsub(/^(["'])(.*)\1$/, '\2') if value.respond_to?(:gsub)
          value
        end

        private

        def normalize(data)
          data = symbolize(data)
          data[:env] = normalize_env(data[:env])
          data
        end

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

        # TODO: move this to travis-env_vars

        def normalize_env(env)
          symbolize(to_h(env || {}))
        rescue TypeError
          raise error(env)
        end

        def to_h(obj)
          case obj
          when Hash
            obj
          when Array
            obj.flat_map { |obj| to_h(obj).to_a }.to_h
          else
            parse(obj.to_s.strip)
          end
        end

        def parse(str)
          vars = ShVars::String.new(str).parse
          vars.map { |lft, rgt| [lft, cast(unquote(rgt))] }
        rescue ShVars::ParseError
          puts "[travis-conditions] Cannot normalize env var (#{str.inspect} given)"
          []
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

        QUOTE = /^(["'])(.*)\1$/

        def unquote(str)
          (QUOTE =~ str && ::Regexp.last_match(2)) || str
        end

        def error(arg)
          ArgumentError.new("Invalid env data (#{arg.inspect} given)")
        end
      end
    end
  end
end
