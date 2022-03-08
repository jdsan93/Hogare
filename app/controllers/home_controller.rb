class HomeController < ApplicationController
skip_before_action :user_logged_in?
  
  def index
  end

end
