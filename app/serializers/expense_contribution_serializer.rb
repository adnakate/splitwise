class ExpenseContributionSerializer < ActiveModel::Serializer
  attributes :id, :amount_contributed, :date_time, :user_id, :user_name

  belongs_to :expense

  def date_time
    self.object.created_at.strftime("%d/%m/%Y, %H:%M:%S")
  end

  def user_id
    self.object.user.id
  end

  def user_name
    self.object.user.first_name + ' ' + self.object.user.last_name
  end
end