class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :description, :expense_type, :contribution_type, :payer_id, :payer_name

  def payer_id
    self.object.payer.id
  end

  def payer_name
    self.object.payer.first_name + ' ' + self.object.payer.last_name
  end
end