# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_non_active_user, only: [:create]
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to works_path, notice: "guestuserでログインしました。"
  end
  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  
  def reject_non_active_user
    user = User.find_by(email: params[:user][:email])
    return if !user
    if user.valid_password?(params[:user][:password]) && (user.is_active == false)
      redirect_to new_user_session_path, alert: "停止中のアカウントです。"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
