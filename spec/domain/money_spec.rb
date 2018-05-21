# frozen_string_literal: true

require 'money'

describe Money do
  it 'has an amount' do
    money = described_class.new(amount: 100)
    expect(money.amount).to eq 100
  end

  it 'is possible to sum two amounts' do
    first = described_class.new(amount: 1)
    second = described_class.new(amount: 2)

    result = first + second

    expect(result.amount).to eq(3)
  end

  it 'is possible to subtract two amounts' do
    first = described_class.new(amount: 1)
    second = described_class.new(amount: 2)

    result = first - second

    expect(result.amount).to eq(-1)
  end

  it 'is possible to negate the amount' do
    money = described_class.new(amount: 1)

    result = -money

    expect(result.amount).to eq(-1)
  end

  it 'is possible to compare two amounts' do
    smaller = described_class.new(amount: 1)
    bigger = described_class.new(amount: 2)

    true_comparison = (smaller < bigger)
    false_comparison = (bigger < smaller)

    expect(true_comparison).to eq true
    expect(false_comparison).to eq false
  end

  it 'is a value object' do
    first = described_class.new(amount: 1)
    second = described_class.new(amount: 1)
    third = described_class.new(amount: 2)

    equal_comparison = (first == second)
    different_comparison = (second == third)

    expect(equal_comparison).to eq true
    expect(different_comparison).to eq false
  end

  describe '.zero' do
    it 'returns a money object with zero amount' do
      money = described_class.zero

      expect(money).to be_instance_of(described_class)
      expect(money.amount).to eq 0
    end
  end

  describe '#negative?' do
    it 'returns true for negative amounts' do
      expect(Money.new(amount: -1).negative?).to eq true
    end

    it 'returns false for positive amounts' do
      expect(Money.new(amount: 1).negative?).to eq false
    end

    it 'returns false for 0' do
      expect(Money.new(amount: 0).negative?).to eq false
    end
  end
end
