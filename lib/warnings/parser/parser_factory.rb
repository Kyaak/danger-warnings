require_relative 'bandit_parser'

module Warnings
  # Factory class for supported parsers.
  class ParserFactory
    AVAILABLE_PARSERS = {
      bandit: BanditParser
    }.freeze

    def self.get(type)
      key = type
      key = key.to_sym if key.method_exists?(:to_sym)
      parser = AVAILABLE_PARSERS[key]
      raise("Parser '#{key}' not supported.") if parser.nil?

      parser.new
    end
  end
end
