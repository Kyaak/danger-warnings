# frozen_string_literal: true

module Warnings
  module Assets
    ASSETS_DIR = Pathname.new(File.expand_path('../assets', __dir__))
    EMPTY_TXT = "#{ASSETS_DIR}/empty.txt"
    EMPTY_XML = "#{ASSETS_DIR}/empty.xml"

    BANDIT_JSON = "#{ASSETS_DIR}/bandit/bandit_json.json"
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit/bandit_json_empty.json"
    BANDIT_MISSING_RESULTS = "#{ASSETS_DIR}/bandit/bandit_json_missing_results.json"

    PYLINT_PARSEABLE = "#{ASSETS_DIR}/pylint/pylint_parseable.txt"

    RUBOCOP_JSON = "#{ASSETS_DIR}/rubocop/rubocop_json.json"
    RUBOCOP_MULTI_JSON = "#{ASSETS_DIR}/rubocop/rubocop_json_multi_offenses.json"
    RUBOCOP_SIMPLE_NO_COPS = "#{ASSETS_DIR}/rubocop/rubocop_simple_no_cops.txt"
    RUBOCOP_SIMPLE_COPS = "#{ASSETS_DIR}/rubocop/rubocop_simple_cops.txt"
    RUBOCOP_CLANG_NO_COPS = "#{ASSETS_DIR}/rubocop/rubocop_clang_no_cops.txt"
    RUBOCOP_CLANG_COPS = "#{ASSETS_DIR}/rubocop/rubocop_clang_cops.txt"

    CPPCHECK_XML = "#{ASSETS_DIR}/cppcheck/cppcheck.xml"
    CPPCHECK_EMPTY_RESULTS_XML = "#{ASSETS_DIR}/cppcheck/cppcheck_empty_results.xml"
    CPPCHECK_EMPTY_ERRORS_XML = "#{ASSETS_DIR}/cppcheck/cppcheck_empty_errors.xml"
    CPPCHECK_MULTI_LOCATION_XML = "#{ASSETS_DIR}/cppcheck/cppcheck_multi_location.xml"

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
      cop: 'Style/Semicolon',
      message: 'Do not use semicolons to terminate expressions.',
      line: 82
    }.freeze

    CPPCHECK_FIRST_ISSUE = {
      location: 'src/private/api/manager/ManagerStatusHelperImpl.cpp',
      line: 59,
      category: 'useStlAlgorithm',
      message: 'Consider using std::find_if algorithm instead of a raw loop.',
      severity: :low
    }.freeze

    CPPCHECK_MULTI_LOCATION_ISSUE = {
      locations: [
        {
          location: 'src/private/database/domain/DbTrack.h',
          line: 68,
          info: "Derived variable 'DbTrack::COLUMN_CREATED_DATE'"
        },
        {
          location: 'src/private/database/domain/DbBaseModel.h',
          line: 263,
          info: "Parent variable 'DbBaseModel::COLUMN_CREATED_DATE'"
        }
      ],
      category: 'duplInheritedMember',
      message: "The class 'DbTrack' defines member variable with name 'COLUMN_CREATED_DATE' also defined in its parent class 'DbBaseModel'.",
      severity: :medium
    }.freeze
  end
end
