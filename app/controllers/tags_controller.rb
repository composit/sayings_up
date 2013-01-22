class TagsController < ApplicationController
  load_and_authorize_resource
  respond_to :html

  def index
    @tags = @tags.sort { |x, y| x.taggings.count <=> y.taggings.count }
    @tags = @tags.delete_if { |tag| tag.taggings.length < 1 }
  end

  def show
  end
end
