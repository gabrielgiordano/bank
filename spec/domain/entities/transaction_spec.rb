# frozen_string_literal: true

require 'entities/transaction'

describe Entities::Transaction do
  describe '.new' do
    it 'id is nil as default' do
      transaction = described_class.new(account_id: double, amount: double)

      expect(transaction.id).to eq nil
    end

    it 'date is Date.today as default' do
      transaction = described_class.new(account_id: double, amount: double)

      expect(transaction.date).to eq Date.today
    end
  end
end
