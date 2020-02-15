module Api
  module V1
    class AppsController < ApplicationController
      def index
        @apps = App.all
        render 'api/v1/apps/index.json.jbuilder'
      end

      def show
        @app = App.find_by(package_id: params[:id]) || App.none
        render 'api/v1/apps/show.json.jbuilder'
      end
    end
  end
end