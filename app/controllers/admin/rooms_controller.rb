class Admin::RoomsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @user = User.find(params[:user_id])
    @rooms = @user.rooms
  end
  
end
