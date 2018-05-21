# frozen_string_literal: true

require 'bigdecimal'

class Money
  attr_reader :amount

  def initialize(amount:)
    @amount = BigDecimal(amount)
  end

  def self.zero
    return @@zero if defined? @@zero
    @@zero = new(amount: 0)
  end

  def +(other)
    self.class.new(amount: amount + other.amount)
  end

  def -(other)
    self.class.new(amount: amount - other.amount)
  end

  def -@
    self.class.new(amount: -amount)
  end

  def <(other)
    other.instance_of?(self.class) &&
      amount < other.amount
  end

  def ==(other)
    other.instance_of?(self.class) &&
      amount == other.amount
  end

  def negative?
    amount.negative?
  end

  def to_d
    amount
  end
end
