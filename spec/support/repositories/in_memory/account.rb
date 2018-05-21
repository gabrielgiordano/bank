# frozen_string_literal: true

module Repositories
  module InMemory
    class Account
      def initialize
        @accounts = {}
        @account_counter = 1
        @transaction_counter = 1
      end

      def find(account_id)
        @accounts[account_id]
      end

      def where_and_lock(id:)
        Array(id).sort.map do |account_id|
          find(account_id)
        end.compact
      end

      def save(account)
        if account.id.nil?
          account.id = @account_counter
          @account_counter += 1
        end

        account.transactions.each do |t|
          t.id = @transaction_counter
          t.account_id = account.id
          @transaction_counter += 1
        end

        @accounts[account.id] = account
      end

      def transaction
        yield
      end
    end
  end
end
