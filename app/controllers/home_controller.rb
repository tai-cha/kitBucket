class HomeController < ApplicationController
  def index
    @recent_versions = Version.order("created_at DESC").limit(3)
  end
end
