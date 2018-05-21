# frozen_string_literal: true

module Entities
  class Account
    include Conversions

    attr_writer :id
    attr_reader :id, :transactions

    def initialize(id: nil, balance: Money.zero, transactions: [])
      @id = id
      @initial_balance = Money(balance)
      @transactions = transactions
    end

    def debit(amount)
      transactions << Transaction.new(account_id: id, amount: Money(-amount))
    end

    def credit(amount)
      transactions << Transaction.new(account_id: id, amount: Money(amount))
    end

    def balance
      transactions.reduce(@initial_balance) do |memo, transaction|
        memo += transaction.amount
      end
    end
  end
end
