require_relative 'parser/parser_factory'
require_relative 'markdown_util'
require_relative 'severity'

module Warnings
  # Base reporter class to define attributes and common method to create a report.
  class Reporter
    DEFAULT_INLINE = false
    DEFAULT_FILTER = true
    DEFAULT_FAIL = false
    DEFAULT_NAME = 'Report'.freeze
    ERROR_PARSER_NOT_SET = 'Parser is not set.'.freeze
    ERROR_FILE_NOT_SET = 'File is not set.'.freeze
    ERROR_HIGH_SEVERITY = '%s has high severity errors.'.freeze

    # The name of this reporter. It is used to identify your report in the comments.
    attr_writer :name
    # Whether to comment a markdown report or do an inline comment on the file.
    #
    # @return [Bool] Use inline comments.
    attr_accessor :inline
    # Whether to filter and report only for changes files.
    # If this is set to false, all issues are of a report are included in the comment.
    #
    # @return [Bool] Filter for changes files.
    attr_accessor :filter
    # Whether to fail the PR if any high issue is reported.
    #
    # @return [Bool] Fail on high issues.
    attr_accessor :fail_error
    # The parser to be used to read issues out of the file.
    #
    # @return [Symbol] Name of the parser.
    attr_reader :parser
    # The file path to parse.
    #
    # @return [String] Path to file.
    attr_accessor :file
    # Defines the baseline of file paths if needed.
    # @example src/main/java
    #
    # @return [String] Path baseline for git files.
    attr_accessor :baseline
    # The generated implementation of the :parser.
    #
    # @return [Parser] Parser implementation
    attr_reader :parser_impl
    attr_reader :issues

    def initialize(danger)
      @danger = danger
      @inline = DEFAULT_INLINE
      @filter = DEFAULT_FILTER
      @fail_error = DEFAULT_FAIL
      @issues = []
    end

    # Start generating the report.
    # Evaluate, parse and comment the found issues.
    def report
      validate
      parse
      filter_issues
      comment
    end

    # Define the parser to be used.
    #
    # @@raise If no implementation can be found for the symbol.
    # @param value [Symbol] A symbol key to match a parser implementation.
    def parser=(value)
      @parser = value
      @parser_impl = ParserFactory.create(value)
    end

    # Return the name of this reporter.
    # The name can have 3 values:
    #   - The name set using #name=
    #   - If name is not set, the name of the parser
    #   - If name and parser are not set, a DEFAULT_NAME
    #
    # @return [String] Name of the reporter.
    def name
      result = @name
      result ||= "#{@parser_impl.name} #{DEFAULT_NAME}" if @parser_impl
      result || DEFAULT_NAME
    end

    private

    def filter_issues
      return unless filter

      git_files = @danger.git.modified_files + @danger.git.added_files
      @issues.select! do |issue|
        git_files.include?(issue_filename(issue))
      end
    end

    def issue_filename(item)
      result = ''
      if baseline
        result << baseline
        result << '/' unless baseline.chars.last == '/'
      end
      result << item.file_name
    end

    def validate
      raise ERROR_PARSER_NOT_SET if @parser_impl.nil?
      raise ERROR_FILE_NOT_SET if @file.nil?
    end

    def parse
      @parser_impl.parse(file)
      @issues = @parser_impl.issues
    end

    def comment
      return if @issues.empty?

      inline ? inline_comment : markdown_comment
    end

    def inline_comment
      @issues.each do |issue|
        text = inline_text(issue)
        if fail_error && high_issue?(issue)
          @danger.fail(text, line: issue.line, file: issue.file_name)
        else
          @danger.warn(text, line: issue.line, file: issue.file_name)
        end
      end
    end

    def inline_text(issue)
      "#{issue.severity.to_s.capitalize}\n[#{issue.id}-#{issue.name}]\n#{issue.message}"
    end

    def markdown_comment
      text = MarkdownUtil.generate(name, @issues)
      @danger.markdown(text)
      @danger.fail(format(ERROR_HIGH_SEVERITY, name)) if fail_error && high_issues?
    end

    def high_issues?
      result = false
      @issues.each do |issue|
        result = true if high_issue?(issue)
      end
      result
    end

    def high_issue?(issue)
      issue.severity.eql?(:high)
    end
  end
end
