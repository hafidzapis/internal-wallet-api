FactoryBot.define do
  factory :user do
    user_name { 'test_user' }
    password { BCrypt::Password.create('password123') }
    authentication_token { 'abcd' }
  end
end
