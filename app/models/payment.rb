class Payment < ApplicationRecord
  validates_presence_of :amount,
                        message: Proc.new { |payment, data| "You must provide #{data[:attribute]}" }

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  def create_expense_record
    expense = Expense.create(payer_id: sender_id, total_amount: amount, description: 'Payment',
                             expense_type: 'payment', contribution_type: 'settlement')
    expense.create_expense_contribution_record(receiver_id)
  end
end
