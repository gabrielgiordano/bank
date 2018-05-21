# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/repositories/account'
require 'repositories/account'

RSpec.describe Repositories::Account do
  include_examples 'Account Repository', described_class
end
