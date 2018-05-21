# frozen_string_literal: true

require 'use_cases/validators/transfer'

describe UseCases::Validators::Transfer do
  let(:account) { double(:account, balance: 100) }

  describe '#valid' do
    it 'is false when amount is negative' do
      use_case = double(:use_case,
                        amount: -10,
                        source_account: account,
                        destination_account: account)
      validator = described_class.new(use_case)

      expect(validator.valid?).to eq false
      expect(validator.errors).to eq [:negative_amount]
    end

    it 'is false when one account is missing' do
      use_case = double(:use_case,
                        amount: 10,
                        source_account: nil,
                        destination_account: account)
      validator = described_class.new(use_case)

      expect(validator.valid?).to eq false
      expect(validator.errors).to eq [:account_not_found]
    end

    it 'is false when there is not enough balance in the source account' do
      use_case = double(:use_case,
                        amount: 1000,
                        source_account: account,
                        destination_account: account)
      validator = described_class.new(use_case)

      expect(validator.valid?).to eq false
      expect(validator.errors).to eq [:insufficient_balance]
    end

    it 'is true when everything is correct' do
      use_case = double(:use_case,
                        amount: 10,
                        source_account: account,
                        destination_account: account)
      validator = described_class.new(use_case)

      expect(validator.valid?).to eq true
      expect(validator.errors).to eq []
    end
  end
end
