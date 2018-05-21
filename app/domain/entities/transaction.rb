# frozen_string_literal: true

require 'date'

module Entities
  class Transaction
    attr_writer :id, :account_id
    attr_reader :id, :account_id, :amount, :date

    def initialize(id: nil, account_id:, amount:, date: Date.today)
      @id = id
      @account_id = account_id
      @amount = amount
      @date = date
    end
  end
end
