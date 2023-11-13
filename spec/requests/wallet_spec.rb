# spec/requests/api/v1/wallet_controller_spec.rb

require 'rails_helper'

RSpec.describe "Api::V1::WalletController", type: :request do
  describe 'GET /api/v1/wallet/balance' do
    context 'when user is authenticated' do
      it 'returns the wallet details, balance, and transaction history' do
        entity = Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'), authentication_token: 'abcd')
        wallet = Wallet.create!(entity: entity, balance: 0)
        entity.wallet = wallet

        get '/api/v1/wallet/balance', headers: { 'Authorization' => "Bearer abcd" }
        expect(response).to have_http_status(200)

        wallet_response = JSON.parse(response.body)
        expect(wallet_response).to have_key('wallet')
        expect(wallet_response).to have_key('balance')
        expect(wallet_response).to have_key('transaction_history')
      end
    end

    context 'when user is not authenticated' do
      it 'returns a 401 status' do
        get '/api/v1/wallet/balance'
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/wallet/create' do
    context 'when user is not authenticated' do
      it 'returns a 401 status' do
        post '/api/v1/wallet/create'
        expect(response).to have_http_status(401)
      end
    end
  end
end
