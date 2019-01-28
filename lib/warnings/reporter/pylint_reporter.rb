# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/pylint_parseable_parser'
require_relative '../parser/pylint_json_parser'

module Warnings
  # Reporter implementation for Pylint.
  class PylintReporter < Reporter
    NAME = 'Pylint'

    def parsers
      {
        parseable: PylintParseableParser,
        json: PylintJsonParser
      }
    end

    def default_name
      NAME
    end

    def default_format
      :parseable
    end
  end
end
