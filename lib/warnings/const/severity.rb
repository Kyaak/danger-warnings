# frozen_string_literal: true

module Warnings
  # Defines severity levels.
  module Severity
    LOW = :low
    MEDIUM = :medium
    HIGH = :high

    ERROR = 'error'
    WARNING = 'warning'
    STYLE = 'style'
    PERFORMANCE = 'performance'
    PORTABILITY = 'portability'
    INFORMATION = 'information'
  end
end
