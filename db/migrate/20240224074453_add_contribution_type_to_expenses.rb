class AddContributionTypeToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :contribution_type, :string
  end
end
