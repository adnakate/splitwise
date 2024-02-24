class RemoveDatetimeFromExpencesAndPayments < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :date_time
    remove_column :payments, :date_time
  end
end
