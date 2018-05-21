# frozen_string_literal: true

require_relative '../config/initializers/context'
require 'support/repositories/in_memory/account'

class Boot
  def self.init
    Context.register_repository(
      key: :account,
      repository: Repositories::InMemory::Account.new
    )
  end
end
