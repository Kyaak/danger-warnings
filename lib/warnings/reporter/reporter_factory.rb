# frozen_string_literal: true

require_relative 'bandit_reporter'
require_relative 'pylint_reporter'
require_relative 'rubocop_reporter'
require_relative 'cppcheck_reporter'
require_relative 'android_lint_reporter'
require_relative 'checkstyle_reporter'
require_relative 'ktlint_reporter'

module Warnings
  # Factory class for supported reporter.
  class ReporterFactory
    ERROR_NOT_SUPPORTED = 'Reporter \'%s\' not supported.'
    REPORTERS = {
      android_lint: AndroidLintReporter,
      bandit: BanditReporter,
      checkstyle: CheckstyleReporter,
      cppcheck: CppcheckReporter,
      rubocop: RubocopReporter,
      pylint: PylintReporter,
      ktlint: KtlintReporter
    }.freeze

    # Create a new parser implementation.
    #
    # @param key [Symbol] A symbol to identify the reporter.
    # @param danger [Danger] Danger implementation.
    # @raise If no implementation could be found for the key.
    # @return [Reporter] Implementation
    def self.create(key, danger)
      reporter = REPORTERS[key]
      raise(format(ERROR_NOT_SUPPORTED, key)) if reporter.nil?

      reporter.new(danger)
    end
  end
end
