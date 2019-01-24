# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/rubocop_simple_parser'
require_relative '../parser/rubocop_json_parser'

module Warnings
  # Reporter implementation for RuboCop.
  class RubocopReporter < Reporter
    NAME = 'RuboCop'

    def parsers
      {
        simple: RubocopSimpleParser,
        json: RubocopJsonParser
      }
    end

    def default_name
      NAME
    end

    def default_format
      :simple
    end
  end
end
