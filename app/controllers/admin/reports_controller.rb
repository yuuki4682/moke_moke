class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @reports = Report.all.order(created_at: :desc)
  end
  
end
