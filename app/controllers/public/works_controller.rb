class Public::WorksController < ApplicationController
  
  def index
    @works = Work.page(params[:page])
  end

  def new
    @work = Work.new
  end
  
  def create
    @work = current_user.works.new(work_params)
    if @work.save
      redirect_to work_path(@work)
    else
      render :new
    end
  end

  def show
    @work = Work.find(params[:id])
  end

  def edit
    @work = Work.find(params[:id])
  end
  
  def update
    @work = Work.find(params[:id])
    if @work.update
      redirect_to work_path(@work)
    else
      render :edit
    end
  end
  
  def destroy
    work = Work.find(params[:id])
    work.destoy
    redirect_to work_path(work)
  end
  
  private
  
  def work_params
    params.require(:work).permit(:title,:caption,:main_image,sub_images: [])
  end
  
end
