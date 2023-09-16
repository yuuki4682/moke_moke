class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notifications = current_user.reverse_notifications.all.order(created_at: :desc)
    #未読の通知を既読に更新
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    
    @tags = Tag.all
  end
  
end
