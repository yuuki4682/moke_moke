class Admin::RoomsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @rooms = @user.rooms
  end
end
