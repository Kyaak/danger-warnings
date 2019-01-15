require_relative 'parser/parser_factory'
require_relative 'markdown_util'
require_relative 'severity'

module Warnings
  # Base reporter class to define attributes and common method to create a report.
  class Reporter
    DEFAULT_NAME = 'Report'.freeze

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
    attr_accessor :fail
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
    # A danger instance.
    attr_writer :danger

    # Start generating the report.
    # Evaluate, parse and comment the found issues.
    def report
      parse
      comment
    end

    # Define the parser to be used.
    #
    # @@raise If no implementation can be found for the symbol.
    # @param value [Symbol] A symbol key to match a parser implementation.
    def parser=(value)
      @parser = value
      @parser_impl = ParserFactory.get(value)
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

    def parse
      @parser_impl.parse(file)
    end

    def comment
      inline ? inline_comment : markdown_comment
    end

    def inline_comment
      parser_impl.issues.each do |issue|
        text = "[#{issue.severity.to_s.upcase}-#{issue.id}-#{issue.name}]\n#{issue.message}"
        @danger.warning(line: issue.line, file: issue.file, message: text)
      end
    end

    def markdown_comment
      text = MarkdownUtil.generate(name, @parser_impl.issues)
      @danger.markdown(text)
    end
  end
end
