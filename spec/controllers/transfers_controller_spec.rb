# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransfersController, type: :controller do
  let(:account_repository) { Context.repository(key: :account) }

  describe 'POST #create' do
    let!(:source_account) { account_repository.save(Entities::Account.new(balance: 1000)) }
    let!(:destiny_account) { account_repository.save(Entities::Account.new(balance: 1000)) }

    it 'moves money from one account to the another one' do
      post :create, params: {
        amount: 100,
        source_account_id: source_account.id,
        destination_account_id: destiny_account.id
      }

      expect(response.code).to eq '200'
    end

    context 'when there is not enough balance' do
      it 'returns a bad request' do
        post :create, params: {
          amount: 999_999,
          source_account_id: source_account.id,
          destination_account_id: destiny_account.id
        }

        expect(response.code).to eq '400'
      end
    end

    context 'when amount is negative' do
      it 'returns a bad request' do
        post :create, params: {
          amount: -999_999,
          source_account_id: source_account.id,
          destination_account_id: destiny_account.id
        }

        expect(response.code).to eq '400'
      end
    end

    context 'when one account is missing' do
      it 'returns a 404' do
        post :create, params: {
          amount: 100,
          source_account_id: -1,
          destination_account_id: destiny_account.id
        }

        expect(response.code).to eq '404'
      end
    end
  end
end
