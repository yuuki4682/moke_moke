class Public::SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @word = params[:word]
    
    @users = User.search(@word)
    works = Work.search(@word)
    @works = Kaminari.paginate_array(works).page(params[:page]).per(5)
    @tags = Tag.search(@word)
  end
end
