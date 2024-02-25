class Api::V1::UsersController < ApplicationController
  before_action :check_friends_expenses_params, only: [:friends_expenses]
  # For all other api calls you need user ids, so we need list users api. 
  def index
    users = User.order(:created_at).page params[:page]
    render json: { users: ActiveModel::Serializer::CollectionSerializer.new(users) }, status: :ok
  end

  def dashboard
    balance, message = current_user.total_balance
    owed_by_hash, you_owe_hash, setteled_hash = current_user.records_sheet
    render json: { balance: balance.round(2),
                   message: message,
                   owed_by_hash: owed_by_hash,
                   you_owe_hash: you_owe_hash,
                   setteled_hash: setteled_hash }, status: :ok
  end

  def friends_expenses
    friend = User.where(id: params[:friend_id]).last
    return render json: { errors: 'Invalid friend id' }, status: :unprocessable_entity if !friend.present?
    expenses = friend.list_expenses
    payments = friend.list_payments
    expenses = expenses.page params[:page]
    payments = payments.page params[:page]
    render json: { expenses: ActiveModel::Serializer::CollectionSerializer.new(expenses),
                   payments: ActiveModel::Serializer::CollectionSerializer.new(payments) }, status: :ok
  end

  private

  def check_friends_expenses_params
    return render json: { errors: 'Enter friend id' }, status: :unprocessable_entity if !params[:friend_id].present?
    render json: { errors: 'Invalid friend id' }, status: :unprocessable_entity if current_user.id == params[:friend_id].to_i
  end
end
