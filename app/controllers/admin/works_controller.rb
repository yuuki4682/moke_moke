class Admin::WorksController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @work = Work.find(params[:id])
  end
  
end
