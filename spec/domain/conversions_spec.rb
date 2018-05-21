# frozen_string_literal: true

require 'money'
require 'conversions'

describe Conversions do
  include Conversions

  describe '.Money' do
    it 'returns the same instance when given a Money object' do
      money = Money.new(amount: 100)
      converted_money = Money(money)

      expect(converted_money.object_id).to eq(money.object_id)
    end

    it 'creates a Money instance when given a Numeric type' do
      money = Money(100)

      expect(money).to be_instance_of(Money)
      expect(money.amount).to eq(100)
    end

    it "raises error when can't convert" do
      expect { Money(true) }.to raise_error TypeError
    end
  end
end
