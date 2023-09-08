class Public::TagsController < ApplicationController
  
  def search
    @tags = Tag.all
    @tag = Tag.find(params[:id])
    @works = @tag.works
  end
  
end
