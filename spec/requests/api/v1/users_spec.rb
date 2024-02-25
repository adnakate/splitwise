require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'list dashboard details' do
    before(:each) do 
      @user_1 = FactoryBot.create(:user)
      @user_2 = FactoryBot.create(:user)
      @user_3 = FactoryBot.create(:user)
      @user_4 = FactoryBot.create(:user)
      @expense_1 = FactoryBot.create(:expense, payer: @user_1, total_amount: 2000)
      FactoryBot.create(:expense_contribution, user: @user_1, expense: @expense_1, amount_contributed: 500)
      FactoryBot.create(:expense_contribution, user: @user_2, expense: @expense_1, amount_contributed: -500)
      FactoryBot.create(:expense_contribution, user: @user_3, expense: @expense_1, amount_contributed: -500)
      FactoryBot.create(:expense_contribution, user: @user_4, expense: @expense_1, amount_contributed: -500)
    end

    it "should return dashboard details" do
      get '/api/v1/users/dashboard', headers: login(@user_1.email)
      expect(response).to have_http_status :ok
    end

    it "should check balance details and message" do
      get '/api/v1/users/dashboard', headers: login(@user_1.email)
      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)["balance"]).to eq(1500)
      expect(JSON.parse(response.body)["message"]).to eq("Over all you are owed.")
    end
  end

  describe 'list friends expenses' do
    before(:each) do 
      @user_5 = FactoryBot.create(:user)
      @user_6 = FactoryBot.create(:user)
      @expense_2 = FactoryBot.create(:expense, payer: @user_5, total_amount: 2000)
      @expense_3 = FactoryBot.create(:expense, payer: @user_6, total_amount: 2000)
      FactoryBot.create(:expense_contribution, user: @user_5, expense: @expense_2, amount_contributed: 1000)
      FactoryBot.create(:expense_contribution, user: @user_6, expense: @expense_2, amount_contributed: -1000)
      FactoryBot.create(:expense_contribution, user: @user_5, expense: @expense_3, amount_contributed: -1000)
      FactoryBot.create(:expense_contribution, user: @user_6, expense: @expense_3, amount_contributed: 1000)
      FactoryBot.create(:payment, sender: @user_5, receiver: @user_6, amount: 1000)
      FactoryBot.create(:payment, sender: @user_6, receiver: @user_5, amount: 2000)
    end

    it "should list friends expenses" do
      get '/api/v1/users/friends_expenses', params: {
        friend_id: @user_6.id
      }, headers: login(@user_5.email)
      expect(response).to have_http_status :ok
    end
  end

  describe 'should check errors' do
    before(:each) do 
      @user_7 = FactoryBot.create(:user)
    end

    it "should ask for friend id" do
      get '/api/v1/users/friends_expenses', params: {}, headers: login(@user_7.email)
      expect(response).to have_http_status :unprocessable_entity
    end

    it "should ask for valid friend id" do
      get '/api/v1/users/friends_expenses', params: {
        friend_id: @user_7.id
      }, headers: login(@user_7.email)
      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
