# spec/requests/api/v1/sessions_request_spec.rb

require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  # let(:entity) { Entity.create(:entity, user_name: 'test_user', password: BCrypt::Password.create('password123')) }

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      it 'returns a valid authentication token' do
        entity = Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'))
        post '/api/v1/login', params: { user_name: entity.user_name, password: 'password123' }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns a 401 authentication error' do
        entity = Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'))
        post '/api/v1/login', params: { user_name: entity.user_name, password: 'wrong_password' }
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['meta']['error_message']).to be_present
      end
    end
  end

  describe 'GET /api/v1/current_user' do
    context 'when user is authenticated' do
      it 'returns the details of the current user' do
        Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'), authentication_token: 'abcd' )
        get '/api/v1/current_user', headers: { 'Authorization' => "Bearer abcd" }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['user_name']).to be_present
      end
    end


    context 'when user is not authenticated' do
      it 'returns a 404 status' do
        get '/api/v1/current_user'
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/logout' do
    context 'when user is authenticated' do
      it 'invalidates the authentication token' do
        entity = Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'), authentication_token: 'abcd' )
        delete '/api/v1/logout', headers: { 'Authorization' => "Bearer abcd" }
        expect(response).to have_http_status(200)
        entity.reload
        expect(entity.authentication_token).to be_nil
      end
    end

    context 'when user is not authenticated' do
      it 'returns a 401 status' do
        delete '/api/v1/logout'
        Entity.create!(user_name: 'test_user', type: 'User', password: BCrypt::Password.create('password123'), authentication_token: 'abcd' )
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['meta']['error_message']).to be_present
      end
    end
  end
end
