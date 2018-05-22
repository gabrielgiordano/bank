# frozen_string_literal: true

require 'money'
require 'conversions'
require 'entities/account'
require 'use_cases/result'
require 'use_cases/check_balance'

describe UseCases::CheckBalance do
  include Conversions

  let(:repository) { Context.repository(key: :account) }

  context 'when account exists' do
    it 'returns account balance' do
      account = Entities::Account.new(balance: 50)
      repository.save(account)

      result = described_class.new(account_id: account.id).call

      expect(result).to be_success
      expect(result.data).to eq account_id: account.id, balance: Money(50)
    end
  end

  context 'when there is no account' do
    it 'returns failure with reason' do
      result = described_class.new(account_id: -1).call

      expect(result).to be_failure
      expect(result.errors).to eq [:account_not_found]
    end
  end
end
