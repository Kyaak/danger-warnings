# frozen_string_literal: true

module Warnings
  module Assets
    ASSETS_DIR = Pathname.new(File.expand_path('../assets', __dir__))
    EMPTY_FILE = "#{ASSETS_DIR}/empty.txt"

    BANDIT_JSON = "#{ASSETS_DIR}/bandit_json.json"
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_json_empty.json"
    BANDIT_MISSING_RESULTS = "#{ASSETS_DIR}/bandit_json_missing_results.json"
    PYLINT_PARSEABLE = "#{ASSETS_DIR}/pylint_parseable.txt"
    RUBOCOP_JSON = "#{ASSETS_DIR}/rubocop_json.json"
    RUBOCOP_MULTI_JSON = "#{ASSETS_DIR}/rubocop_json_multi_offenses.json"
    RUBOCOP_SIMPLE = "#{ASSETS_DIR}/rubocop_simple.txt"
    RUBOCOP_CLANG = "#{ASSETS_DIR}/rubocop_clang.txt"

    BANDIT_FIRST_ISSUE = {
      code: "2852         except ImportError:\n2853             import pickle\n2854         with open(filename, 'wb') as outf:\n",
      filename: 'example/ply/yacc_1.py',
      issue_confidence: 'HIGH',
      issue_severity: :low,
      issue_text: 'Consider possible security implications associated with pickle module.',
      line_number: 2853,
      line_range: [
        2853
      ],
      more_info: 'https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b403-import-pickle',
      test_id: 'B403',
      test_name: 'blacklist'
    }.freeze

    PYLINT_FIRST_ISSUE = {
      filename: 'test_project/__init__.py',
      line: '1',
      category: 'F403',
      message: "'from test_project import *' used; unable to detect undefined names"
    }.freeze

    RUBOCOP_FIRST_ISSUE_FULL = {
      path: 'spec/lib/danger/danger_core/plugins/dangerfile_gitlab_plugin_spec.rb',
      offenses: [
        {
          severity: 'convention',
          message: 'Do not use semicolons to terminate expressions.',
          cop_name: 'Style/Semicolon',
          corrected: false,
          location: {
            line: 82,
            column: 65,
            length: 1
          }
        }
      ]
    }.freeze

    RUBOCOP_FIRST_ISSUE_SHORT = {
      path: 'spec/lib/danger/danger_core/plugins/dangerfile_gitlab_plugin_spec.rb',
      severity: 'C',
      message: 'Do not use semicolons to terminate expressions.',
      line: 82
    }.freeze
  end
end
