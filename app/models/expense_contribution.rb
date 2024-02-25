class ExpenseContribution < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  paginates_per 20
end
