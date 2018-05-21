# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates :account_id, :amount, :date, presence: true
end
