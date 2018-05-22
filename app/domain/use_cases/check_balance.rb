# frozen_string_literal: true

module UseCases
  class CheckBalance
    attr_reader :account_repository, :account_id

    def initialize(
      account_repository: Context.repository(key: :account),
      account_id:
    )
      @account_repository = account_repository
      @account_id = account_id
    end

    def call
      account = account_repository.find(account_id)

      if account
        Result.success(data: {
          account_id: account_id,
          balance: account.balance
        })
      else
        Result.failure(errors: [:account_not_found])
      end
    end
  end
end
