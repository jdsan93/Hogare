class DateCleanerController < ApplicationController
  before_action :user_admin
  before_action :authenticate_information

  def edit
    @cleaner = Cleaner.find(params[:id])
  end

  def update
    @cleaner = Cleaner.find(params[:id])
    @cleaner.update(date_cleaner_params)
    redirect_to the_users_path
  end

  private

    def date_cleaner_params
      params.require(:cleaner).permit(:start_date, :end_date)
    end

    def user_admin
      redirect_to (root_path) unless current_user.user_type == "admin"
    end    
end
