class Public::SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @word = params[:word]
    
    @users = User.search(@word)
    @works = Work.search(@word)
    @tags = Tag.search(@word)
  end
end
