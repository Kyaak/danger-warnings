# frozen_string_literal: true

require_relative 'reporter/reporter_factory'

module Danger
  # Create uniform issue reports for different parser types.
  # @example Create a basic bandit reporter.
  #       warnings.reporter(
  #         name: 'Bandit Report',
  #         id: :bandit,
  #         file: reporter/bandit.json
  #       )
  #
  # @example Create a bandit reporter and comment inline for all files.
  #       warnings.reporter(
  #         name: 'Bandit Report',
  #         id: :bandit,
  #         file: reporter/bandit.json,
  #         inline: true,
  #         filter: false
  #       )
  #
  # @see Kyaak/danger-warnings
  # @tags warnings, danger, parser, issues, reporter
  class DangerWarnings < Plugin
    ERROR_ID_NOT_SET = 'danger.warnings requires an :id'
    # Whether to comment as markdown reporter or do an inline comment on the file.
    #
    # This will be set as default for all reporters used in this danger run.
    # It can still be overridden by setting the value when using #report.
    #
    # @return [Bool] Use inline comments.
    attr_accessor :inline
    # Whether to filter and reporter only for changes files.
    # If this is set to false, all issues are of a reporter are included in the comment.
    #
    # This will be set as default for all reporters used in this danger run.
    # It can still be overridden by setting the value when using #report.
    #
    # @return [Bool] Filter for changes files.
    attr_accessor :filter
    # Whether to fail the PR if any high issue is reported.
    #
    # This will be set as default for all reporters used in this danger run.
    # It can still be overridden by setting the value when using #report.
    #
    # @return [Bool] Fail on high issues.
    attr_accessor :fail_error

    def initialize(dangerfile)
      super(dangerfile)
    end

    # Create a reporter for given arguments.
    #         name: 'Bandit Report',
    #         parser: :bandit,
    #         file: reporter/bandit.json,
    #         inline: true,
    #         filter: false
    # @param args List of arguments to be used.
    # @return [Reporter] The current reporter class which handles the issues.
    def report(*args)
      options = args.first
      reporter = create_reporter(options)
      reporter.report
      reporter
    end

    private

    # rubocop:disable Metrics/AbcSize
    def create_reporter(options)
      id = options[:id]
      raise ERROR_ID_NOT_SET if id.nil?

      reporter = Warnings::ReporterFactory.create(id, self)
      reporter.format = options[:format]
      reporter.name = options[:name]
      reporter.file = options[:file]
      reporter.baseline = options[:baseline]
      reporter.inline = options[:inline] unless options[:inline].nil?
      reporter.filter = options[:filter] unless options[:filter].nil?
      reporter.fail_error = options[:fail_error] unless options[:fail_error].nil?
      reporter
      # rubocop:enable Metrics/AbcSize
    end
  end
end
