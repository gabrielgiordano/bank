# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:repository) { Context.repository(key: :account) }

  describe 'GET #show' do
    context 'when there is an account' do
      it 'returns the balance' do
        account = Entities::Account.new(balance: 50)
        repository.save(account)

        get :show, params: { id: account.id }

        body = JSON.parse response.body

        expect(response.code).to eq '200'
        expect(body['data']['balance']['amount']).to eq '50.0'
      end
    end

    context 'when there is no account' do
      it 'returns 404' do
        get :show, params: { id: -1 }

        body = JSON.parse response.body

        expect(response.code).to eq '404'
      end
    end
  end
end
