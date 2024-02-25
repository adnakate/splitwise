class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :sender_id, :sender_name, :receiver_id, :receiver_name, :date_time

  def sender_name
    self.object.sender.first_name + ' ' + self.object.sender.last_name
  end

  def receiver_name
    self.object.receiver.first_name + ' ' + self.object.receiver.last_name
  end

  def date_time
    self.object.created_at.strftime("%d/%m/%Y, %H:%M:%S")
  end
end