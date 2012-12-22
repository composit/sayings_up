class CommentsController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :entry, through: :exchange
  load_and_authorize_resource :comment, through: :entry

  respond_to :json

  def create
    @comment.user_id = current_user.id
    @exchange.save!
  end
end
