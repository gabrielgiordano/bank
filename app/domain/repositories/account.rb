# frozen_string_literal: true

module Repositories
  class Account
    class << self
      def find(account_id)
        account = ::Account.find(account_id)
        Entities::Account.new(id: account.id, balance: account.balance)
      rescue ActiveRecord::RecordNotFound
        nil
      end

      def where_and_lock(id:)
        # Order result by id to prevent deadlocks
        accounts = ::Account.lock.where(id: id).order(:id)
        accounts.map do |account|
          Entities::Account.new(id: account.id, balance: account.balance)
        end
      rescue ActiveRecord::RecordNotFound
        nil
      end

      def save(account)
        transaction do
          account_model = create_model(::Account, account.id)
          account_model.balance = account.balance.to_d
          account_model.save!
          account.id = account_model.id

          account.transactions.each do |t|
            t.account_id = account.id

            transaction_model = create_model(::Transaction, t.id)
            transaction_model.account_id = t.account_id
            transaction_model.amount = t.amount.to_d
            transaction_model.date = t.date
            transaction_model.save!
            t.id = transaction_model.id
          end

          account
        end
      end

      def transaction
        ::Account.transaction do
          yield
        end
      end

      private

      # Avoid issuing one query when the id is null.
      # When the id is null we are creating a new entry in the system.
      def create_model(klass, id)
        if id.nil?
          klass.new
        else
          klass.find_or_initialize_by(id: id)
        end
      end
    end
  end
end
