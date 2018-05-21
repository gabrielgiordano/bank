# frozen_string_literal: true

module UseCases
  class Transfer
    attr_reader :account_repository, :amount, :source_account_id,
                :destination_account_id, :validator

    def initialize(
      account_repository: Context.repository(key: :account),
      validator: Validators::Transfer,
      amount:,
      source_account_id:,
      destination_account_id:
    )
      @account_repository = account_repository
      @validator = validator.new(self)
      @amount = Money.new(amount: amount)
      @source_account_id = source_account_id.to_i
      @destination_account_id = destination_account_id.to_i
    end

    def call
      account_repository.transaction do
        if validator.valid?
          source_account.debit(amount)
          destination_account.credit(amount)

          account_repository.save(source_account)
          account_repository.save(destination_account)

          Result.success
        else
          Result.failure(errors: validator.errors)
        end
      end
    end

    def source_account
      @source_account ||= accounts.find { |a| a&.id == source_account_id }
    end

    def destination_account
      @destination_account ||= accounts.find do |a|
        a&.id == destination_account_id
      end
    end

    private

    # It is necessary to find both accounts at the same time
    # to prevent deadlocks.
    def accounts
      @accounts ||= account_repository.where_and_lock(
        id: [source_account_id, destination_account_id]
      )
    end
  end
end
