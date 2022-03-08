class CleanersController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_path
  end

  def show
    redirect_to root_path
  end

  def edit
    @cleaner = Cleaner.find(params[:id])
  end

  def update
    @cleaner = Cleaner.find_by(user_id: current_user.id)
    @cleaner.update(cleaner_params)
    redirect_to root_path
  end
  
  def destroy
  end

  private
  
    def cleaner_params
      params.require(:cleaner).permit(:name, :phone)
    end 

    def correct_user
      @cleaner = Cleaner.find(params[:id])
      redirect_to (root_path) unless @cleaner.user_id == current_user.id || current_user.user_type == "admin"
    end
end
