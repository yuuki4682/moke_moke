class Admin::ChatsController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    @sender = @room.users[0]
    @reciever = @room.users[1]
    @chats = @room.chats
  end
end
