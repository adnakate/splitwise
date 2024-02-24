FactoryBot.define do
  sequence :email do |n|
    charset = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
    email = Array.new(16) { charset.sample }.join
    "#{email}@example.com"
  end
end

FactoryBot.define do
  factory :user, :class => 'User' do
    password '12345678'
    password_confirmation '12345678'
    first_name 'Abhijit'
    last_name 'Nakate'
    email
  end
end