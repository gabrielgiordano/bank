# frozen_string_literal: true

module UseCases
  module Validators
    class Transfer
      attr_reader :errors

      def initialize(use_case)
        @use_case = use_case
        @errors = []
      end

      def valid?
        execute_validations
        @errors.empty?
      end

      def execute_validations
        @errors = []
        return @errors << :negative_amount if negative_amount?
        return @errors << :account_not_found if any_account_missing?
        return @errors << :insufficient_balance if not_enough_balance?
      end

      def negative_amount?
        @use_case.amount.negative?
      end

      def any_account_missing?
        @use_case.source_account.nil? || @use_case.destination_account.nil?
      end

      def not_enough_balance?
        @use_case.source_account.balance < @use_case.amount
      end
    end
  end
end
