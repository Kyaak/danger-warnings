module Warnings
  # Defines severity levels and provides helper methods.
  module SeverityUtil
    LOW = :low
    MEDIUM = :medium
    HIGH = :high

    module_function

    # Map a common shortened severity [R/C/W/E/F0000] to a defined severity level.
    #
    # @param name [String] The shortened severity without '[]'
    # @return [Symbol] Mapped severity level.
    def rcwef_short(name)
      char = name.chars.first.downcase
      case char
        when 'r', 'c'
          LOW
        when 'w'
          MEDIUM
        when 'e', 'f'
          HIGH
        else
          LOW
      end
    end

    # Map a common full severity to a defined severity level.
    #
    # @param name [String] The shortened severity without '[]'
    # @return [Symbol] Mapped severity level.
    def rcwef_full(name)
      case name.downcase
        when 'refactor', 'convention'
          LOW
        when 'warning'
          MEDIUM
        when 'error', 'fatal'
          HIGH
        else
          LOW
      end
    end
  end
end
