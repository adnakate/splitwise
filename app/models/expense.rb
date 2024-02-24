class Expense < ApplicationRecord
  validates_presence_of :total_amount, :description, :expense_type, :contribution_type,
                        message: Proc.new { |user, data| "You must provide #{data[:attribute]}" }

  belongs_to :payer, class_name: 'User'
  has_many :expense_contributions
  has_many :participants, through: :expense_contributions, source: :user

  def create_expense_contributions(params)
    if params[:contribution_type] == 'equal'
      expense_contributions_array = create_equal_expense_contributions(params)
    else
      expense_contributions_array = create_unequal_expense_contributions(params)
    end
    ExpenseContribution.import expense_contributions_array
    # Here you can send nofification to users by iterating over user ids in background job.
    # If you do not want to use bulk insert, you can send notification on after create of expense contribution too.
  end

  def create_expense_contribution_record(receiver_id)
    ExpenseContribution.create(user_id: receiver_id, expense_id: id, amount_contributed: total_amount * -1)
  end

  private

  def create_equal_expense_contributions(params)
    contributors_count = user_ids(params).count
    per_head_amount = (params[:total_amount].to_f / contributors_count.to_f).round(2)
    expense_contributions_array = []
    user_ids(params).each do |user_id|
      expense_contribution_object = expense_contribution_object(user_id, per_head_amount)
      expense_contributions_array << expense_contribution_object
    end
    expense_contributions_array
  end

  def create_unequal_expense_contributions(params)
    expense_contributions_array = []
    user_ids(params).each do |user_id, per_head_amount|
      expense_contribution_object = expense_contribution_object(user_id, per_head_amount)
      expense_contributions_array << expense_contribution_object
    end
    expense_contributions_array
  end

  def expense_contribution_object(user_id, per_head_amount)
    per_head_amount = per_head_amount * -1 if payer_id.to_i != user_id.to_i
    ExpenseContribution.new(user_id: user_id, expense_id: id, amount_contributed: per_head_amount)
  end

  def user_ids(params)
    JSON.parse(params[:user_ids])
  end
end
