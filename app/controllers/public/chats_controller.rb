class Public::ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]
  before_action :is_matching_login_user, only: [:destroy]
  
  
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    
    #current_userと@userのroomが存在しなければ、同一のroomと紐づいたuser_roomを両者に作成する
    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end
    
    @chats = @room.chats.order(created_at: :desc)
    @chat = Chat.new
  end
  
  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    @chat.create_notification_chat
    redirect_to request.referer 
  end
  
  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to request.referer
  end
  
  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id, :receiver_id)
  end
  
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to mypage_path
    end
  end
  
  def is_matching_login_user
    chat = Chat.find(params[:id])
    user = chat.user
    unless user.id == current_user.id
      redirect_to mypage_path
    end
  end
  
end
