# spec/factories/transaction.rb
FactoryBot.define do
  factory :transaction do
    association :source_wallet, factory: :wallet
    association :target_wallet, factory: :wallet
    amount { 300.0 }
    wallet { source_wallet }
    type { 'Deposit' }

    trait :withdrawal do
      type { 'Withdrawal' }
    end

    trait :transfer do
      type { 'Deposit' }
    end
  end

  factory :deposit, parent: :transaction, class: 'Deposit' do
    type { 'Deposit' }
  end
end
