# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :transactions

  validates :balance, presence: true
end
