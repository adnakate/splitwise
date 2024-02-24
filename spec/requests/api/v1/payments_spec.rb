require 'rails_helper'

RSpec.describe "Api::V1::Payments", type: :request do
  describe 'successfully creates a payment' do
    subject(:perform) do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      post '/api/v1/payments', params: {
        "sender_id": user_1.id,
        "receiver_id": user_2.id,
        "amount": 2000
      }, headers: login(user_1.email)
    end
    include_examples 'creates a new object', Payment
    include_examples 'creates a new object', Expense
    include_examples 'creates a new object', ExpenseContribution
  end

  describe 'should return different errors' do
    it "should return amount should be present " do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      post '/api/v1/payments', params: {
        "sender_id": user_1.id,
        "receiver_id": user_2.id,
      }, headers: login(user_1.email)
      expect(response).to have_http_status :unprocessable_entity
    end

    it "should return sender_id should be present " do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      post '/api/v1/payments', params: {
        "receiver_id": user_2.id,
        "amount": 2000
      }, headers: login(user_1.email)
      expect(response).to have_http_status :unprocessable_entity
    end

    it "should return receiver_id should be present " do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      post '/api/v1/payments', params: {
        "sender_id": user_1.id,
        "amount": 2000
      }, headers: login(user_1.email)
      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
