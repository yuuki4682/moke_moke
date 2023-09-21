class Public::TagsController < ApplicationController
  
  def search
    @tags = Tag.top(5)
    @tag = Tag.find(params[:id])
    @works = @tag.works.page(params[:page]).per(5)
  end
  
end
