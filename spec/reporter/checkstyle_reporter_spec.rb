# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/checkstyle_reporter'

module Warnings
  describe CheckstyleReporter do
    before do
      @dangerfile = testing_dangerfile
      @reporter = CheckstyleReporter.new(@dangerfile)
      @reporter.inline = true
      @reporter.filter = false

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    it '#default_name' do
      expect(@reporter.default_name).to eq(CheckstyleReporter::NAME)
    end

    it '#default_parser' do
      expect(@reporter.default_format).to eq(:xml)
    end

    it 'runs default xml parser' do
      @reporter.file = Assets::CHECKSTYLE_XML
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs xml parser' do
      @reporter.file = Assets::CHECKSTYLE_XML
      @reporter.format = :xml
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end
  end
end
