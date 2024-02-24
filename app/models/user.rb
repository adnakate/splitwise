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
end
