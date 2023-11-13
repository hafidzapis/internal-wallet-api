require 'rails_helper'

RSpec.describe 'Transaction API', type: :request do
  let(:user) { create(:user, user_name: 'test_user', password: BCrypt::Password.create('password123'), authentication_token: 'abcd') }
  let(:wallet) { create(:wallet, entity: user, balance: 3000) }
  let(:source_wallet_id) { wallet.id }
  let(:target_wallet) { create(:wallet, entity: user, balance: 0) }
  let(:target_wallet_id) { target_wallet.id }
  let(:amount) { 100.0 }

  describe 'POST /api/v1/transfer/deposit' do
    it 'creates a deposit transaction' do
      post '/api/v1/transfer/deposit', params: { source_wallet_id: source_wallet_id, amount: amount }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(200)
      # Add more expectations as needed
    end
  end

  describe 'POST /api/v1/transfer/withdrawal' do
    it 'creates a withdrawal transaction' do
      deposit_transaction = create(:deposit, source_wallet: wallet)
      post '/api/v1/transfer/withdraw', params: { source_wallet_id: source_wallet_id, amount: amount }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(200)
      # Add more expectations as needed
    end

    it 'fails with insufficient balance' do
      wallet.update(balance: 50) # Set a low balance
      post '/api/v1/transfer/withdraw', params: { source_wallet_id: source_wallet_id, amount: 100.0 }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(422)
      # Add more expectations as needed
    end

    it 'fails with exceeding transaction limit' do
      post '/api/v1/transfer/withdraw', params: { source_wallet_id: source_wallet_id, amount: 5000.0 }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(422)
      # Add more expectations as needed
    end
  end

  describe 'POST /api/v1/transfer/create_transfer' do
    it 'creates a fund transfer transaction' do
      deposit_transaction = create(:deposit, source_wallet: wallet)
      post '/api/v1/transfer/transfer', params: { source_wallet_id: source_wallet_id, target_wallet_id: target_wallet_id, amount: amount }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(200)
      # Add more expectations as needed
    end

    it 'fails with insufficient balance' do
      wallet.update(balance: 50) # Set a low balance
      post '/api/v1/transfer/transfer', params: { source_wallet_id: source_wallet_id, target_wallet_id: target_wallet_id, amount: 100.0 }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(422)
      # Add more expectations as needed
    end

    it 'fails with exceeding transaction limit' do
      post '/api/v1/transfer/transfer', params: { source_wallet_id: source_wallet_id, target_wallet_id: target_wallet_id, amount: 5000.0 }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(422)
      # Add more expectations as needed
    end

    it 'fails with transaction frequency limit exceeded' do
      # Simulate exceeding the transaction frequency limit
      allow(TransactionService).to receive(:validate_transaction_frequency).and_raise(Rest::Errors::TransactionError.new(422, {}, 'Transaction frequency exceeded limit'))
      post '/api/v1/transfer/transfer', params: { source_wallet_id: source_wallet_id, target_wallet_id: target_wallet_id, amount: 100.0 }, headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(422)
      # Add more expectations as needed
    end

  end
end
