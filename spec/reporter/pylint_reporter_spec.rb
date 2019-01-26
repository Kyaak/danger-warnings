# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/pylint_reporter'

module Warnings
  describe PylintReporter do
    before do
      @dangerfile = testing_dangerfile
      @reporter = PylintReporter.new(@dangerfile)
      @reporter.inline = true
      @reporter.filter = false

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    it '#default_name' do
      expect(@reporter.default_name).to eq(PylintReporter::NAME)
    end

    it '#default_parser' do
      expect(@reporter.default_format).to eq(:parseable)
    end

    it 'runs default parseable parser' do
      @reporter.file = Assets::PYLINT_PARSEABLE_NO_CATEGORIES
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs parseable parser' do
      @reporter.file = Assets::PYLINT_PARSEABLE_NO_CATEGORIES
      @reporter.format = :parseable
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end
  end
end
