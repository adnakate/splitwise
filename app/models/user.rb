class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates_uniqueness_of :email, message: INVALID_EMAIL
  validates_presence_of :first_name, :last_name,
                        message: Proc.new { |user, data| "You must provide #{data[:attribute]}" }
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, message: INVALID_EMAIL

  has_many :expense_contributions
  has_many :expenses, through: :expense_contributions
  has_many :sent_payments, class_name: 'Payment', foreign_key: :sender_id
  has_many :received_payments, class_name: 'Payment', foreign_key: :receiver_id

  paginates_per 20

  def total_balance
    owed_by = Expense.joins(:expense_contributions)
                     .where(payer_id: id)
                     .where.not(expense_contributions: { user_id: id })
                     .sum('expense_contributions.amount_contributed')
    you_owe = ExpenseContribution.where(user_id:id)
                                 .where('amount_contributed < ?', 0)
                                 .sum('expense_contributions.amount_contributed')
    total_balance = (owed_by * -1) - (you_owe * -1)
    return total_balance, 'You owe no one, no one owes you.' if total_balance == 0
    return total_balance, 'Over all you are owed.' if total_balance > 0
    return total_balance, 'You owe overall.'
  end

  def records_sheet
    all_owed_by_records = owed_by_records
    all_you_owe_records =  you_owe_records
    all_owed_by_hash = create_hash(all_owed_by_records, -1)
    all_you_owe_hash = create_hash(all_you_owe_records, 1)
    owed_by_hash, you_owe_hash, setteled_hash = after_calcutaion_records(all_owed_by_hash, all_you_owe_hash)
    return owed_by_hash, you_owe_hash, setteled_hash
  end

  def list_expenses
    expense_contributions.joins(:expense)
                         .includes(:user, expense: :payer)
                         .where.not("expenses.expense_type = ?", 'payment')
                         .order('created_at desc')
  end

  def list_payments
    Payment.includes(:sender, :receiver)
           .where("sender_id = ? OR receiver_id = ?", id, id)
           .order('created_at desc')
  end

  private

  def owed_by_records
    Expense.joins(expense_contributions: :user)
           .where(payer_id: id)
           .where.not(expense_contributions: { user_id: id })
           .group('users.id')
           .pluck('users.id, users.first_name, users.last_name, SUM(expense_contributions.amount_contributed)')
  end

  def you_owe_records
    ExpenseContribution.joins(expense: :payer)
                       .where.not(expenses: { payer_id: id })
                       .where(user_id: id)
                       .where('expense_contributions.amount_contributed < ?', 0)
                       .group('expenses.payer_id, users.first_name, users.last_name',)
                       .pluck('expenses.payer_id, users.first_name, users.last_name, SUM(expense_contributions.amount_contributed)')
  end

  def create_hash(records, multiplier)
    records_hash = {}
    records.each do |record|
      records_hash[record[0]] = {
        name: record[1].strip.camelize + ' ' + record[2].strip.camelize,
        amount: record[3] * multiplier
      }
    end
    records_hash
  end

  def after_calcutaion_records(all_owed_by_hash, all_you_owe_hash)
    owed_by_hash = {}
    you_owe_hash = {}
    setteled_hash = {}
    all_owed_by_hash.each do |user_id, record|
      if all_you_owe_hash[user_id].present?
        difference = record[:amount] - (all_you_owe_hash[user_id][:amount] * -1)
        create_record(owed_by_hash, user_id, record, difference) if difference > 0
        create_record(you_owe_hash, user_id, record, difference) if difference < 0
        create_record(setteled_hash, user_id, record, difference) if difference == 0
      else
        create_record(owed_by_hash, user_id, record, record[:amount])
      end
    end

    all_you_owe_hash.each do |user_id, record|
      if !owed_by_hash[user_id].present? && !you_owe_hash[user_id].present? && !setteled_hash[user_id].present?
        create_record(you_owe_hash, user_id, record, record[:amount])
      end
    end
    return owed_by_hash, you_owe_hash, setteled_hash
  end

  def create_record(desired_hash, user_id, record, difference)
    desired_hash[user_id] = { name: record[:name], amount: difference }
  end
end
