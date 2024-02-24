class Api::V1::ExpensesController < ApplicationController
  before_action :check_params_presence, only: [:create]
  before_action :validate_create_params, only: [:create]

  def create
    expense = Expense.new(create_params)
    if expense.save
      expense.create_expense_contributions(params)
      render json: expense, status: :created
    else
      render json: { errors: expense.errors }, status: :unprocessable_entity
    end
  end

  private

  # Check if the required params are present.
  def check_params_presence
    # I have added contribution type validation in model also. But the flow of the code demands validation here first.
    return render json: { errors: 'Enter contribution type' }, status: :unprocessable_entity if !params[:contribution_type].present?
    render json: { errors: 'Enter user ids' }, status: :unprocessable_entity if !params[:user_ids].present?
  end
  
  # Check if the entered params are valid.
  def validate_create_params
    user_ids = JSON.parse(params[:user_ids])
    if params[:contribution_type] == 'equal'
      check_equally_distribute_conditions(user_ids)
    else
      check_unequally_distribute_conditions(user_ids)
    end
    render json: { errors: 'Invalid amount' }, status: :unprocessable_entity if params[:total_amount].to_f <= 0
  end

   # If we need to split equally it can be done on backend, so taking array of user ids.
  def check_equally_distribute_conditions(user_ids)
    return render json: { errors: 'Enter user ids array' }, status: :unprocessable_entity if user_ids.class != Array
    if user_ids.count == 1 && params[:payer_id] == user_ids.last
      return render json: { errors: 'You cannot owe money to yourself.' }, status: :unprocessable_entity
    end
  end

  # If we need to split unequally backend should receive user id and it's amount from front end in hash.
  def check_unequally_distribute_conditions(user_ids)
    return render json: { errors: 'Enter user ids hash' }, status: :unprocessable_entity if user_ids.class != Hash
    if user_ids.count == 1 && params[:payer_id] == user_ids.keys.last
      return render json: { errors: 'You cannot owe money to yourself.' }, status: :unprocessable_entity
    end
  end

  def create_params
    params.permit(:payer_id, :total_amount, :description, :expense_type, :contribution_type)
  end
end
