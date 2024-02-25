FactoryBot.define do
  factory :expense_contribution do
    amount_contributed 100
    association :user
    association :expense
  end
end
