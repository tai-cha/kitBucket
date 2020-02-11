class AppsController < ApplicationController
  def index
    @packages = App.all
  end

  def show
    @package = App.find_by package_id: params[:app_id]
  end

  def new
    @package = App.new
  end

  def create
    require 'zip'
    require 'active_support/core_ext/array'

    @package = nil
    unless params[:app][:file].content_type == 'application/zip'
      flash[:red] = "zipファイル以外は読み込めません。(アップロードされたファイル: #{params[:app][:file].original_filename})"
      redirect_to new_app_path
      return
    end
    begin
      Zip::File.open(params[:app][:file].path) do |zip|
        appdata = JSON.parse(zip.read("define.json")).with_indifferent_access
        @package = App.find_or_initialize_by(package_id: appdata[:id])
        @package.name = appdata[:name]
        @package.author = appdata[:author]
        unless @package.version.find_by(name: appdata[:version]).blank?
          flash[:red] = "すでに#{appdata[:id]} #{appdata[:version]}は存在しています。"
          redirect_to new_app_path
          return
        end
        @version = @package.version.new(name: appdata[:version])
        @version.unzip_and_send_file_to_aws(params[:app][:file])
        @version.save
      end
       redirect_to apps_path if @package.save
    rescue Zip::Error
      flash[:red] = "Zipファイルを正しく読み込めませんでした。\nファイル形式が正しく、破損していないことを確認してください。"
      redirect_to new_app_path
    end
  end
end
