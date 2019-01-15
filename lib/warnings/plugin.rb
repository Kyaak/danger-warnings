require_relative 'reporter'

module Danger
  class DangerWarnings < Plugin
    DEFAULT_INLINE = false
    DEFAULT_FILTER = true
    DEFAULT_FAIL = false

    # Whether to comment a markdown report or do an inline comment on the file.
    #
    # This will be set as default for all reporters used in this danger run.
    # It can still be overridden by setting the value when using #report.
    #
    # @return [Bool] Use inline comments.
    attr_accessor :inline
    # Whether to filter and report only for changes files.
    # If this is set to false, all issues are of a report are included in the comment.
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
    attr_accessor :fail

    def initialize(_dangerfile)
      @inline = DEFAULT_INLINE
      @filter = DEFAULT_FILTER
      @fail = DEFAULT_FAIL
    end

    def report(*args)
      options = args.first
      reporter = create_reporter(options)
      reporter.danger = self
      reporter.report
    end

    private

    # rubocop:disable Metrics/AbcSize
    def create_reporter(options)
      reporter = Warnings::Reporter.new
      reporter.danger = self
      reporter.parser = options[:parser]
      reporter.name = options[:name]
      reporter.file = options[:file]
      reporter.baseline = options[:baseline]
      reporter.inline = options[:inline].nil? ? inline : options[:inline]
      reporter.filter = options[:filter].nil? ? filter : options[:filter]
      reporter.fail = options[:fail].nil? ? raise : options[:fail]
      reporter
      # rubocop:enable Metrics/AbcSize
    end
  end
end
