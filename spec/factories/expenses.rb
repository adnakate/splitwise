FactoryBot.define do
  factory :expense do
    total_amount 1000
    description "description"
    expense_type "expense"
    contribution_type "equal"
    association :payer
  end
end
