require 'json'

module Warnings
  # Base parser class to define common methods.
  class Parser
    # All issues found by the parser.
    #
    # @return [Array<Issue>]
    attr_accessor :issues

    def initialize
      @issues = []
    end

    # Defines all supported file types for the parser.
    #
    # @return [Array<Symbol>] Array of file types.
    def file_types
      raise 'Method should be overridden'
    end

    # Execute the parser.
    # Read the file and create an array of issues.
    #
    # @return [Array<Issue>] Array of issues.
    def parse(_file)
      raise 'Method should be overridden'
    end

    def name
      raise 'Method should be overridden'
    end

    protected

    def json(file_path)
      content = read_file(file_path)
      JSON.parse(content)
    end

    private

    def read_file(file_path)
      check_extname(file_path)
      raise("File '#{file_path}' does not exist.") unless File.exist?(file_path)

      File.read(file_path)
    end

    def check_extname(file_path)
      ext = File.extname(file_path).delete('.')
      raise("File type '#{ext}' is not supported for parser #{self.class.name}.") unless file_types.include?(ext.to_sym)
    end
  end
end
