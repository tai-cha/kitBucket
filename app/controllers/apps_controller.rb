class AppsController < ApplicationController
  def index
    @packages = App.all
  end

  def show
    @package = App.find_by package_id: params[:app_id]
  end

  def new
    redirect_to login_path unless logged_in?
    @package = App.new
  end

  def create
    require 'zip'
    require 'active_support/core_ext/array'

    @package = nil
    unless %w[application/zip application/x-zip-compressed].include?(params[:app][:file].content_type)
      flash[:red] = "zipファイル以外は読み込めません。(アップロードされたファイル: #{params[:app][:file].original_filename})"
      redirect_to new_app_path
      return
    end
    begin
      Zip::File.open(params[:app][:file].path) do |zip|
        appdata = JSON.parse(zip.read("define.json")).with_indifferent_access
        logger.debug appdata
        @package = App.find_or_initialize_by(package_id: appdata[:id])
        @package.name = appdata[:name]
        @package.author = appdata[:author]
        @package.user = current_user
        unless @package.versions.find_by(name: appdata[:version]).blank?
          flash[:red] = "すでに#{appdata[:id]} #{appdata[:version]}は存在しています。"
          redirect_to new_app_path
          return
        end
        @version = @package.versions.new(name: appdata[:version])
        @version.unzip_and_send_file_to_aws(params[:app][:file])
      end
      if @package.save
        @version.save
        flash[:green] = "アプリをアップロードしました。"
        if params[:kpt]
         unless current_user&.kpt_token.present?
           flash[:red] = "kptトークンが登録されていません。"
           return render 'new'
         end
         unless Kpt::Registerer.app_registered?(@package&.package_id)
           Kpt::Registerer.register_app(current_user.kpt_token, @package.name, @package.package_id)
         end
         if Kpt::Registerer.register_version(current_user.kpt_token, @package.package_id, @version.name, @version.file_dir_url)
           flash[:green] = "アプリをアップロードしkptに登録しました。"
         else
           flash[:red] = "kptへのバージョン登録ができませんでした。手動でのバージョン追加をお試し下さい。"
         end
        end
        redirect_to apps_path
      else
        flash.now[:red] = "アプリの登録に失敗しました"
        render 'new'
      end
    rescue Zip::Error
      flash[:red] = "Zipファイルを正しく読み込めませんでした。\nファイル形式が正しく、破損していないことを確認してください。"
      redirect_to new_app_path
    end
  end
end
