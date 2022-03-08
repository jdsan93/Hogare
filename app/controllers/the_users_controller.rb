class TheUsersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_information
  before_action :user_admin
  
  def index
    email = params[:search_email]
    @the_users = User.where('user_type != (?)',0).search(email).page(params[:page]).per(10)
    # @the_users = User.all.search(email).page(params[:page]).per(10)
  end

  def new
    @the_user = User.new
  end

  def edit
    @the_user = User.find(params[:id])
  end

  def update
    @the_user = User.find(params[:id])

    user_type = @the_user.user_type
    user_type_attributes = determination_user_type_and_add_attributes(@the_user)

    @the_user.update(user_type: user_params[:user_type].to_i)
    @the_user = @the_user.reload
 
    add_to_new_table(@the_user, user_type_attributes, user_type)

    redirect_to the_users_path
  end

  def create
    @the_user = User.new(user_params.except(:user_type))
    @the_user.user_type = user_params[:user_type].to_i 
    if @the_user.save
      redirect_to the_users_path
    else
      render 'new'
    end
  end

  def destroy
    @the_user = User.find(params[:id])
    @the_user.destroy
    redirect_to the_users_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
    end

    def determination_user_type_and_add_attributes(the_user)
      if the_user.user_type == "client"
        client = Client.find_by(user_id: the_user.id)
        client_new = client.attributes.except("id")
        return client_new

      elsif the_user.user_type == "cleaner"
        cleaner = Cleaner.find_by(user_id: the_user.id)
        cleaner_new = cleaner.attributes.except("id", "start_date", "end_date")
        return cleaner_new 

      else
        admin = Admin.find_by(user_id: the_user.id)
        admin_new = admin.attributes.except("id")
        return admin_new
      end
    end
 
    def add_to_new_table(the_user, user_type_attributes, user_type)
      the_user_new = the_user.attributes
      encrypted_password = the_user.encrypted_password
  
      if user_type == "client" && the_user.user_type == "admin"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password )
  
        admin_create = Admin.find_by(user_id: the_user_create.id)
        admin_create.update(user_type_attributes)
        
      elsif user_type == "client" && the_user.user_type == "cleaner"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password)
     
        cleaner_create = Cleaner.find_by(user_id: the_user_create.id)
        cleaner_create.update(user_type_attributes)
        

      elsif user_type == "cleaner" && the_user.user_type == "client"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password)
  
        client_create = Client.find_by(user_id: the_user_create.id)
        client_create.update(user_type_attributes)

      elsif user_type == "cleaner" && the_user.user_type == "admin"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password)
  
        admin_create = Admin.find_by(user_id: the_user_create.id)
        admin_create.update(user_type_attributes)

      elsif user_type == "admin" && the_user.user_type == "client"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password)
  
        client_create = Client.find_by(user_id: the_user_create.id)
        client_create.update(user_type_attributes)

      elsif user_type == "admin" && the_user.user_type == "cleaner"
        the_user_create = delete_user_and_create(the_user, the_user_new, encrypted_password)
  
        cleaner_create = Cleaner.find_by(user_id: the_user_create.id)
        cleaner_create.update(user_type_attributes)
      end
    end

    def delete_user_and_create(the_user, the_user_new, encrypted_password)
      the_user_create = User.new(the_user_new)
      the_user_create.password = "password"
      the_user_create.password_confirmation = "password"
      the_user_create.encrypted_password = encrypted_password
      the_user.destroy
      the_user_create.save!
      the_user_create
    end

    def user_admin
      redirect_to (root_path) unless current_user.user_type == "admin"
    end
end
