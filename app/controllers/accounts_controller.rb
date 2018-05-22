# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    result = UseCases::CheckBalance.new(account_id: params.require(:id)).call

    if result.success?
      render json: { data: result.data }, status: :ok
    else
      render json: { data: { errors: result.errors } }, status: :not_found
    end
  end
end
