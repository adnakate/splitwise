FactoryBot.define do
  factory :payment do
    amount 1000
    association :sender
    association :receiver
  end
end
