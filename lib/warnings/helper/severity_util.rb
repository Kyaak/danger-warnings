# frozen_string_literal: true

require_relative '../const/severity'

module Warnings
  # Defines severity helper methods.
  module SeverityUtil
    module_function

    # Map a common shortened severity [R/C/W/E/F0000] to a defined severity level.
    #
    # @param name [String] The shortened severity without '[]'
    # @return [Symbol] Mapped severity level.
    def rcwef_short(name)
      char = name.chars.first.downcase
      case char
        when 'r', 'c'
          Severity::LOW
        when 'w'
          Severity::MEDIUM
        when 'e', 'f'
          Severity::HIGH
        else
          Severity::LOW
      end
    end

    # Map a common full severity to a defined severity level.
    #
    # @param name [String] The shortened severity without '[]'
    # @return [Symbol] Mapped severity level.
    def rcwef_full(name)
      case name.downcase
        when 'refactor', 'convention'
          Severity::LOW
        when 'warning'
          Severity::MEDIUM
        when 'error', 'fatal'
          Severity::HIGH
        else
          Severity::LOW
      end
    end
  end
end
