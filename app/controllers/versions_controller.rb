class VersionsController < ApplicationController
  require 'net/http'
  def index
    @app = App.find_by(package_id: params[:app_app_id])
  end

  def show
    @app = App.find_by(package_id: params[:app_app_id])
    @version = @app.version.find_by(name: params[:name])
  end

  def define
    @app = App.find_by(package_id: params[:app_app_id])
    if params[:version_name] == 'latest'
      @version = @app.version.order("created_at DESC").first
    else
      @version = @app.version.find_by(name: params[:version_name])
    end
    redirect_to @version.define_url
  end
end
