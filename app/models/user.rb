class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates_uniqueness_of :email, message: INVALID_EMAIL
  validates_presence_of :first_name, :last_name,
                        message: Proc.new { |tutor, data| "You must provide #{data[:attribute]}" }
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, message: INVALID_EMAIL
end
