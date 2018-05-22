# frozen_string_literal: true

class TransfersController < ApplicationController
  def create
    result = UseCases::Transfer.new(
      amount: params.require(:amount),
      source_account_id: params.require(:source_account_id),
      destination_account_id: params.require(:destination_account_id)
    ).call

    if result.success?
      render json: { data: { status: :ok } }, status: :ok
    else
      render json: { data: { errors: result.errors } }, status: error_to_status(result)
    end
  end

  private

  def error_to_status(result)
    case result.errors.first
    when :negative_amount then :bad_request
    when :account_not_found then :not_found
    when :insufficient_balance then :bad_request
    else :bad_request
    end
  end
end
