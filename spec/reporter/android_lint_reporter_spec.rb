# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/android_lint_reporter'

module Warnings
  describe AndroidLintReporter do
    before do
      @dangerfile = testing_dangerfile
      @reporter = AndroidLintReporter.new(@dangerfile)
      @reporter.inline = true
      @reporter.filter = false

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    it '#default_name' do
      expect(@reporter.default_name).to eq(AndroidLintReporter::NAME)
    end

    it '#default_parser' do
      expect(@reporter.default_format).to eq(:xml)
    end

    it 'runs default xml parser' do
      @reporter.file = Assets::ANDROID_LINT
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs xml parser' do
      @reporter.file = Assets::ANDROID_LINT
      @reporter.format = :xml
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end
  end
end
