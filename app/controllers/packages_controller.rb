class PackagesController < ApplicationController
  def index
    @packages = Package.all
  end

  def show
    @package = Package.find_by package_id: params[:package_id]
  end

  def new
    @package = Package.new
  end

  def create
    require 'zip'
    require 'active_support/core_ext/array'

    @package = nil
    Zip::File.open(params[:package][:file].path) do |zip|
      appdata = JSON.parse(zip.read("define.json")).with_indifferent_access
      @package = Package.find_or_initialize_by(package_id: appdata[:id])
      @package.name = appdata[:name]
      @package.author = appdata[:author]
      @version = @package.version.new(name: appdata[:version])
      @version.decompress_and_send_file_to_aws(params[:package][:file])
      @version.save
    end
     redirect_to packages_path if @package.save
  end
end
