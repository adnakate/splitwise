class Api::V1::UsersController < ApplicationController
  # For all other api calls you need user ids, so we need list users api. 
  def index
    users = User.order(:created_at).page params[:page]
    render json: { users: ActiveModel::Serializer::CollectionSerializer.new(users) }, status: :ok
  end
end
