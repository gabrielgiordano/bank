# frozen_string_literal: true

require 'support/shared_examples/repositories/account'
require 'support/repositories/in_memory/account'

RSpec.describe Repositories::InMemory::Account do
  include_examples 'Account Repository', described_class.new
end
