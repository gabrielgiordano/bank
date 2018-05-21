# frozen_string_literal: true

require 'money'
require 'conversions'
require 'entities/transaction'
require 'entities/account'

describe Entities::Account do
  include Conversions

  describe '.new' do
    it 'id is nil as default' do
      account = described_class.new

      expect(account.id).to eq nil
    end

    it 'transactions is an empty list as default' do
      account = described_class.new

      expect(account.transactions).to be_an(Array)
      expect(account.transactions).to be_empty
    end

    it 'has an initial balance of zero' do
      account = described_class.new

      expect(account.balance).to eq Money.zero
    end
  end

  describe '#debit' do
    it 'creates a new transaction when an amount is debited' do
      account = described_class.new(id: 1)
      amount = Money.new(amount: 100)

      account.debit(amount)

      transactions = account.transactions

      expect(transactions.size).to eq 1
      expect(transactions[0].amount).to eq(-amount)
      expect(transactions[0].account_id).to eq account.id
    end

    it 'converts input to Money' do
      account = described_class.new

      account.debit(100)

      expect(account.transactions[0].amount).to eq Money(-100)
    end
  end

  describe '#credit' do
    it 'creates a new transaction when an amount is credited' do
      account = described_class.new(id: 1)
      amount = Money.new(amount: 100)

      account.credit(amount)

      transactions = account.transactions

      expect(transactions.size).to eq 1
      expect(transactions[0].amount).to eq amount
      expect(transactions[0].account_id).to eq account.id
    end

    it 'converts input to Money' do
      account = described_class.new

      account.credit(100)

      expect(account.transactions[0].amount).to eq Money(100)
    end
  end

  describe '#balance' do
    it 'sums up all transactions' do
      account = described_class.new(balance: 10)

      account.credit(50)
      account.debit(25)
      account.credit(100)
      account.debit(10)

      expect(account.balance).to eq Money(125)
    end

    it 'can be negative' do
      account = described_class.new

      account.debit(50)

      expect(account.balance).to eq Money(-50)
    end
  end
end
