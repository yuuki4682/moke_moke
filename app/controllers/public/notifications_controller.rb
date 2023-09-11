class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notifications = Notification.where(visited_id: current_user.id)
    #未読の通知を既読に更新
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    
    @tags = Tag.all
  end
  
end
