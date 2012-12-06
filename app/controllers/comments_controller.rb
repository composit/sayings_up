class CommentsController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :entry, through: :exchange
  load_and_authorize_resource :comment, through: :entry

  respond_to :json

  def create
    @comment.user = current_user
    @exchange.save
    respond_with @exchange, @entry, @comment
  end
end
