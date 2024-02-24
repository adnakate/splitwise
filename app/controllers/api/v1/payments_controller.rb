class Api::V1::PaymentsController < ApplicationController
  before_action :validate_params, only: [:create]

  def create
    payment = Payment.new(create_params)
    if payment.save
      payment.create_expense_record
      render json: payment, status: :created
    else
      render json: { errors: payment.errors }, status: :unprocessable_entity
    end
  end

  private

  # I have model level validation but better to check amout value here because of the flow.
  def validate_params
    return render json: { errors: 'Enter amount' }, status: :unprocessable_entity if !params[:amount].present?
    render json: { errors: 'Invalid amount' }, status: :unprocessable_entity if params[:amount].to_f <= 0
  end

  def create_params
    params.permit(:amount, :sender_id, :receiver_id)
  end
end
