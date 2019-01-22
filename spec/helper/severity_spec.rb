require_relative '../spec_helper'
require_relative '../../lib/warnings/helper/severity'

module Warnings
  describe Severity do
    context 'valid severity' do
      it 'low' do
        expect(Severity.valid?(:low)).to be_truthy
      end

      it 'medium' do
        expect(Severity.valid?(:medium)).to be_truthy
      end

      it 'high' do
        expect(Severity.valid?(:high)).to be_truthy
      end
    end

    context 'invalid severity' do
      it 'is not valid' do
        expect(Severity.valid?(:unknown)).not_to be_truthy
      end
    end
  end
end
