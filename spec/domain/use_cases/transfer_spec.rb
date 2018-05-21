# frozen_string_literal: true

require 'money'
require 'conversions'
require 'entities/transaction'
require 'entities/account'
require 'use_cases/validators/transfer'
require 'use_cases/result'
require 'use_cases/transfer'

describe UseCases::Transfer do
  include Conversions

  let(:account_repository) { Context.repository(key: :account) }
  let!(:source_account) { account_repository.save(Entities::Account.new) }
  let!(:destiny_account) { account_repository.save(Entities::Account.new) }

  context 'when there is enough balance' do
    it 'moves money from one account to the another one' do
      source_account.credit(100)
      account_repository.save(source_account)

      result = described_class.new(
        amount: 100,
        source_account_id: source_account.id,
        destination_account_id: destiny_account.id
      ).call

      source = account_repository.find(source_account.id)
      destiny = account_repository.find(destiny_account.id)

      expect(result).to be_success
      expect(source.balance).to eq Money.zero
      expect(destiny.balance).to eq Money(100)
    end
  end

  context 'when there is not enough balance' do
    it 'returns a failure with the error' do
      result = described_class.new(
        amount: 1000,
        source_account_id: source_account.id,
        destination_account_id: destiny_account.id
      ).call

      expect(result).to be_failure
      expect(result.errors).to eq [:insufficient_balance]
    end

    it "doesn't charge any account" do
      source_account.credit(100)
      account_repository.save(source_account)

      described_class.new(
        amount: 1000,
        source_account_id: source_account.id,
        destination_account_id: destiny_account.id
      ).call

      source = account_repository.find(source_account.id)
      destiny = account_repository.find(destiny_account.id)

      expect(source.balance).to eq Money(100)
      expect(destiny.balance).to eq Money.zero
    end
  end

  it "doesn't transfer negative amounts of money" do
    result = described_class.new(
      amount: -1000,
      source_account_id: source_account.id,
      destination_account_id: destiny_account.id
    ).call

    expect(result).to be_failure
    expect(result.errors).to eq [:negative_amount]
  end

  it "doesn't transfer when one account is missing" do
    result = described_class.new(
      amount: 1000,
      source_account_id: 999_999_999_999,
      destination_account_id: destiny_account.id
    ).call

    expect(result).to be_failure
    expect(result.errors).to eq [:account_not_found]
  end
end
