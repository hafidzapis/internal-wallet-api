FactoryBot.define do
  factory :wallet do
    association :entity, factory: :user
    balance { 3000 }
  end
end