class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.float :total_amount
      t.text :description
      t.references :payer, foreign_key: { to_table: :users }
      t.datetime :date_time
      t.string :expense_type
      t.timestamps
    end
  end
end
