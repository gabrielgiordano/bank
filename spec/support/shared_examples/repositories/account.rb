# frozen_string_literal: true

require 'money'
require 'conversions'
require 'entities/transaction'
require 'entities/account'

RSpec.shared_examples 'Account Repository' do |repository|
  describe '.save' do
    it 'assigns an id to the entity being saved' do
      account = Entities::Account.new(balance: 10)
      account.credit(10)

      repository.save(account)

      expect(account.id).not_to be_nil
      expect(account.transactions[0].id).not_to be_nil
      expect(account.transactions[0].account_id).not_to be_nil
    end

    it 'returns the saved entity' do
      account = Entities::Account.new

      result = repository.save(account)

      expect(result).to be_an_instance_of(Entities::Account)
    end
  end

  describe '.find' do
    context 'when there is an account' do
      let(:account) { repository.save Entities::Account.new }

      it 'finds the entity in some data store' do
        persisted_account = repository.find(account.id)

        expect(persisted_account.id).to eq account.id
        expect(persisted_account.balance).to eq account.balance
      end
    end

    context 'when there is no account' do
      it 'returns nil' do
        result = repository.find(-1)

        expect(result).to eq nil
      end
    end
  end

  describe '.where_and_lock' do
    context 'with two accounts' do
      it 'retrieves accounts ordered by id' do
        first = repository.save Entities::Account.new
        second = repository.save Entities::Account.new

        result = repository.where_and_lock(id: [second.id, first.id])

        expect(result[0].id).to eq first.id
        expect(result[1].id).to eq second.id
      end
    end

    context "when ids don't exist" do
      it 'returns an empty array' do
        result = repository.where_and_lock(id: [-1, -2])

        expect(result).to be_an_instance_of(Array)
        expect(result.size).to eq 0
      end
    end
  end

  describe '.transaction' do
    it 'yields code inside a transaction' do
      transaction_executed = false

      repository.transaction do
        transaction_executed = true
      end

      expect(transaction_executed).to eq true
    end
  end
end
