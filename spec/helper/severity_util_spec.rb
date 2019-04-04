# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/helper/severity_util'
require_relative '../../lib/warnings/const/severity'

module Warnings
  describe SeverityUtil do
    context 'rcwef_short' do
      it 'maps unknown to low' do
        expect(SeverityUtil.rcwef_short('U000')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('u000')).to eq(Severity::LOW)
      end

      it 'maps R/r to low' do
        expect(SeverityUtil.rcwef_short('R000')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('r000')).to eq(Severity::LOW)
      end

      it 'maps C/c to low' do
        expect(SeverityUtil.rcwef_short('C000')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('c000')).to eq(Severity::LOW)
      end

      it 'maps W/w to medium' do
        expect(SeverityUtil.rcwef_short('W000')).to eq(Severity::MEDIUM)
        expect(SeverityUtil.rcwef_short('w000')).to eq(Severity::MEDIUM)
      end

      it 'maps E/e to high' do
        expect(SeverityUtil.rcwef_short('E000')).to eq(Severity::HIGH)
        expect(SeverityUtil.rcwef_short('e000')).to eq(Severity::HIGH)
      end

      it 'maps F/f to high' do
        expect(SeverityUtil.rcwef_short('F000')).to eq(Severity::HIGH)
        expect(SeverityUtil.rcwef_short('f000')).to eq(Severity::HIGH)
      end
    end

    context 'rcwef_full' do
      it 'maps unknown to low' do
        expect(SeverityUtil.rcwef_short('Unknown')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('unknown')).to eq(Severity::LOW)
      end

      it 'maps Refactor/refactor to low' do
        expect(SeverityUtil.rcwef_short('Refactor')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('refactor')).to eq(Severity::LOW)
      end

      it 'maps Convention/convention to low' do
        expect(SeverityUtil.rcwef_short('Convention')).to eq(Severity::LOW)
        expect(SeverityUtil.rcwef_short('convention')).to eq(Severity::LOW)
      end

      it 'maps Warning/warning to medium' do
        expect(SeverityUtil.rcwef_short('Warning')).to eq(Severity::MEDIUM)
        expect(SeverityUtil.rcwef_short('warning')).to eq(Severity::MEDIUM)
      end

      it 'maps Error/error to high' do
        expect(SeverityUtil.rcwef_short('Error')).to eq(Severity::HIGH)
        expect(SeverityUtil.rcwef_short('error')).to eq(Severity::HIGH)
      end

      it 'maps Fatal/fatal to high' do
        expect(SeverityUtil.rcwef_short('Fatal')).to eq(Severity::HIGH)
        expect(SeverityUtil.rcwef_short('fatal')).to eq(Severity::HIGH)
      end
    end
  end
end
