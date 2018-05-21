# frozen_string_literal: true

module Conversions
  # It marks all following methods as private to prevent the method
  # from cluttering up the public interfaces of our objects.
  # And it makes the methods available as singleton methods on the module.
  # That way, it's possible to access the conversion function without including
  # Conversions, simply by calling e.g. Conversions.Money(100).
  module_function

  def Money(arg)
    case arg
    when Money then arg
    when Numeric then Money.new(amount: arg)
    else
      raise TypeError, "Cannot convert #{arg.inspect} to Money"
    end
  end
end
