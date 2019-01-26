# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/rubocop_reporter'

module Warnings
  describe RubocopReporter do
    before do
      @dangerfile = testing_dangerfile
      @reporter = RubocopReporter.new(@dangerfile)
      @reporter.inline = true
      @reporter.filter = false

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    it '#default_name' do
      expect(@reporter.default_name).to eq(RubocopReporter::NAME)
    end

    it '#default_parser' do
      expect(@reporter.default_format).to eq(:clang)
    end

    it 'runs default parser' do
      @reporter.file = Assets::RUBOCOP_CLANG
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs simple parser' do
      @reporter.file = Assets::RUBOCOP_SIMPLE
      @reporter.format = :simple
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs json parser' do
      @reporter.file = Assets::RUBOCOP_JSON
      @reporter.format = :json
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs clang parser' do
      @reporter.file = Assets::RUBOCOP_CLANG
      @reporter.format = :clang
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end
  end
end
