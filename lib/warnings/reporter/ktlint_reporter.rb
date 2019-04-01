# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/checkstyle_parser'

module Warnings
  # Reporter implementation for AndroidLint.
  class KtlintReporter < Reporter
    NAME = 'Ktlint'

    def parsers
      {
        xml: CheckstyleParser
      }
    end

    def default_name
      NAME
    end

    def default_format
      :xml
    end
  end
end
