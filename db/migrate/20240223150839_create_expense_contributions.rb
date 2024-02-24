class CreateExpenseContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_contributions do |t|
      t.references :user, foreign_key: true
      t.references :expense, foreign_key: true
      t.float :amount_contributed
      t.timestamps
    end
  end
end
