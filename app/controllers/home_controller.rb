class HomeController < ApplicationController
  def index
    @recent_versions = Version.order("created_at DESC").limit(3)
  end

  def mypage
    redirect_to login_path unless logged_in?
    @user = current_user
  end

  def set_token
    redirect_to login_path unless logged_in?
    user = current_user
    if user&.update_columns(kpt_token: params[:kpt][:token])
      flash[:green] = "kptトークンが登録されました。(#{params[:kpt][:token]})"
      redirect_to mypage_path
    else
      flash.now[:red] = 'kptトークンを正常に登録できませんでした。'
      render 'home/mypage'
    end
  end
end
