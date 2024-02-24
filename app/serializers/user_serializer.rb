class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  
  def name
    self.object.first_name.strip.camelize + ' ' + self.object.last_name.strip.camelize
  end
end