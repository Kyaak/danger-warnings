# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/pylint_parseable_parser'

module Warnings
  # Reporter implementation for Pylint.
  class PylintReporter < Reporter
    NAME = 'Pylint'

    def parsers
      {
        parseable: PylintParseableParser
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
