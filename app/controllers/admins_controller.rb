class AdminsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin.update(admin_params)
    redirect_to root_path
  end

  private
  
  def admin_params
    params.require(:admin).permit(:name, :phone)
  end  

  def correct_user
    @admin = Admin.find(params[:id])
    redirect_to (root_path) unless @admin.user_id == current_user.id
  end

end
