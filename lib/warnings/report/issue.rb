module Warnings
  # An issue definition to be used for reports.
  class Issue
    # The name of the file this issue targets.
    #
    # @return [String]
    attr_accessor :file_name
    # The issue category the linter tool provides.
    #
    # @return [String]
    attr_accessor :category
    # The line this issue targets.
    #
    # @return [Integer]
    attr_accessor :line
    # The severity level of this issue.
    # Possible values are `low` `medium` `high`.
    #
    # @return [Symbol]
    attr_accessor :severity
    # The text message describe this issue.
    #
    # @return [String]
    attr_accessor :message
    # The name of the issue id.
    #
    # @return [String]
    attr_accessor :name
  end
end
