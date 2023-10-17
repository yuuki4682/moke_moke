class Public::WorksController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  
  def index
    if params[:like]
      works = Work.sort("like")
      @works = Kaminari.paginate_array(works).page(params[:page]).per(5)
    elsif params[:pv]
      works = Work.sort("pv")
      @works = Kaminari.paginate_array(works).page(params[:page]).per(5)
    else
      @works = Work.all.order(created_at: :desc).page(params[:page]).per(5)
    end
    @tags = Tag.top(5)
  end

  def new
    @work = Work.new
  end
  
  def create
    @work = current_user.works.new(work_params)
    #受け取ったタグのnameを区切って配列にする
    tag_list = params[:work][:name].split(',')
    
    if @work.save
      @work.save_tags(tag_list)
      redirect_to work_path(@work)
    else
      render :new
      @tag_list = @work.tags.pluck(:name).join(',')
    end
  end

  def show
    @work = Work.find(params[:id])
    @comment = Comment.new
    @tags = Tag.all
    
    #閲覧数を加算
    @work.add_view_count(current_user)
  end

  def edit
    @work = Work.find(params[:id])
    @tag_list = @work.tags.pluck(:name).join(',')
  end
  
  def update
    @work = Work.find(params[:id])
    @tag_list = params[:work][:name].split(',')
    
    #サブ画像を個別で削除
    if params[:work][:sub_image_ids]
      params[:work][:sub_image_ids].each do |sub_image_id|
        image = @work.sub_images.find(sub_image_id)
        image.purge
      end
    end
    
    if @work.update(work_params)
      @work.save_tags(@tag_list)
      redirect_to mypage_path
    else
      render :edit
    end
  end
  
  def destroy
    work = Work.find(params[:id])
    work.destroy
    redirect_to request.referer
  end
  
  private
  
  def work_params
    params.require(:work).permit(:title,:caption,:main_image,sub_images: [])
  end
  
  def is_matching_login_user
    work = Work.find(params[:id])
    user = work.user
    unless user == current_user
      redirect_to work_path(work)
    end
  end
  
end
