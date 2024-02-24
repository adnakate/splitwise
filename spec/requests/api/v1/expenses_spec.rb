require 'rails_helper'

RSpec.describe "Api::V1::Expenses", type: :request do
  describe 'successfully creates a expence' do
    subject(:perform) do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      post '/api/v1/expenses', params: {
        "payer_id": user_1.id,
        "total_amount": 2000,
        "description": "Dinner",
        "expense_type": "expense",
        "contribution_type": "equal",
        "user_ids": "[#{user_1.id}, #{user_2.id}]",
      }, headers: login(user_1.email)
    end
    include_examples 'creates a new object', Expense
  end

  describe 'successfully creates a expence with contributors' do
    it "should create one expence successfully with 4 equal contributors" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      user_3 = FactoryBot.create(:user)
      user_4 = FactoryBot.create(:user)
      initial_contrubutions_count = ExpenseContribution.count
      post '/api/v1/expenses', params: {
        "payer_id": user_1.id,
        "total_amount": 2000,
        "description": "Dinner",
        "expense_type": "expense",
        "contribution_type": "equal",
        "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
      }, headers: login(user_1.email)
      expect(response).to have_http_status :created
      expect(ExpenseContribution.count).to eq(initial_contrubutions_count + 4)
      expect([500.0, -500.0]).to include(ExpenseContribution.last(4).first.amount_contributed)
      expect([500.0, -500.0]).to include(ExpenseContribution.last(3).first.amount_contributed)
      expect([500.0, -500.0]).to include(ExpenseContribution.last(2).first.amount_contributed)
      expect([500.0, -500.0]).to include(ExpenseContribution.last.amount_contributed)
    end

    it "should create one expence successfully with 4 unequal contributors" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      user_3 = FactoryBot.create(:user)
      user_4 = FactoryBot.create(:user)
      initial_contrubutions_count = ExpenseContribution.count
      post '/api/v1/expenses', params: {
        "payer_id": user_1.id,
        "total_amount": 2000,
        "description": "Dinner",
        "expense_type": "expense",
        "contribution_type": "unequal",
        "user_ids": "{\"#{user_1.id}\":500,\"#{user_2.id}\":1000, \"#{user_3.id}\":300, \"#{user_4.id}\":200}",
      }, headers: login(user_1.email)
      expect(response).to have_http_status :created
      expect(ExpenseContribution.count).to eq(initial_contrubutions_count + 4)
      expect([500.0, -1000.0, -300.0, -200.0]).to include(ExpenseContribution.last(4).first.amount_contributed)
      expect([500.0, -1000.0, -300.0, -200.0]).to include(ExpenseContribution.last(3).first.amount_contributed)
      expect([500.0, -1000.0, -300.0, -200.0]).to include(ExpenseContribution.last(2).first.amount_contributed)
      expect([500.0, -1000.0, -300.0, -200.0]).to include(ExpenseContribution.last.amount_contributed)
    end

    describe 'should return different errors' do
      it "should return payer_id should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "total_amount": 2000,
          "description": "Dinner",
          "expense_type": "expense",
          "contribution_type": "equal",
          "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end

      it "should return total_amount should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "payer_id": user_1.id,
          "description": "Dinner",
          "expense_type": "expense",
          "contribution_type": "equal",
          "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end

      it "should return description should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "payer_id": user_1.id,
          "total_amount": 2000,
          "expense_type": "expense",
          "contribution_type": "equal",
          "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end

      it "should return expense_type should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "payer_id": user_1.id,
          "total_amount": 2000,
          "description": "Dinner",
          "contribution_type": "equal",
          "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end

      it "should return contribution_type should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "payer_id": user_1.id,
          "total_amount": 2000,
          "description": "Dinner",
          "expense_type": "expense",
          "user_ids": "[#{user_1.id}, #{user_2.id}, #{user_3.id}, #{user_4.id}]",
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end

      it "should return user_ids should be present " do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)
        user_3 = FactoryBot.create(:user)
        user_4 = FactoryBot.create(:user)
        initial_contrubutions_count = ExpenseContribution.count
        post '/api/v1/expenses', params: {
          "payer_id": user_1.id,
          "total_amount": 2000,
          "description": "Dinner",
          "expense_type": "expense",
          "contribution_type": "equal"
        }, headers: login(user_1.email)
        expect(response).to have_http_status :unprocessable_entity
      end
    end

  end
end