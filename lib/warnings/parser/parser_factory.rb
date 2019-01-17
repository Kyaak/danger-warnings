require_relative 'bandit_parser'

module Warnings
  # Factory class for supported parsers.
  class ParserFactory
    ERROR_NOT_SUPPORTED = 'Parser \'%s\' not supported.'.freeze
    AVAILABLE_PARSERS = {
      bandit: BanditParser
    }.freeze

    # Create a new parser implementation.
    #
    # @param key [Symbol|String] A key symbol / name to identify the parser.
    # @raise If no implementation could be found for the key.
    # @return [Parser] Implementation
    def self.create(type)
      key = type
      key = key.to_sym if key.method_exists?(:to_sym)
      parser = AVAILABLE_PARSERS[key]
      raise(format(ERROR_NOT_SUPPORTED, key)) if parser.nil?

      parser.new
    end
  end
end
