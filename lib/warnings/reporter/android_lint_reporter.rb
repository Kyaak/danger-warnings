# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/android_lint_parser'

module Warnings
  # Reporter implementation for Bandit.
  class AndroidLintReporter < Reporter
    NAME = 'AndroidLint'

    def parsers
      {
        xml: AndroidLintParser
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
