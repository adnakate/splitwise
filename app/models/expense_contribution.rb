class ExpenseContribution < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  paginates_per 10
end
