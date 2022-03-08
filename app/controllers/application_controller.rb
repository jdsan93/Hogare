class ApplicationController < ActionController::Base
  before_action :user_logged_in?, except: [:new, :create], unless: :editing_password
    
  def define_user_type
      @user_type = current_user.user_type
  end

  private

  def user_logged_in?
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def editing_password
    params[:controller] == "devise/passwords" && !user_signed_in?
  end

  def authenticate_information
    if current_user.user_type == "client"
      client = Client.find_by(user_id: current_user.id)
      redirect_to (edit_client_path(Client.find_by(user_id: current_user.id))) unless !client.name.blank? && !client.phone.blank?
    elsif current_user.user_type == "admin"
      admin = Admin.find_by(user_id: current_user.id)
      redirect_to (edit_admin_path(Admin.find_by(user_id: current_user.id))) unless !admin.name.blank? && !admin.phone.blank?
    else
      cleaner = Cleaner.find_by(user_id: current_user.id)
      redirect_to (edit_cleaner_path(Cleaner.find_by(user_id: current_user.id))) unless !cleaner.name.blank? && !cleaner.phone.blank? 
    end
  end
end
