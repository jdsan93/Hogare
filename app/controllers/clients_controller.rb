class ClientsController < ApplicationController
  before_action	:correct_user, only: [:edit, :update, :destroy] 
  
  def index
  end

  def show
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find_by(user_id: current_user.id)
    @client.update(client_params)
    if @client.save 
      redirect_to root_path
    else
      render 'edit' 
    end
  end

  def destroy
  end

  def new
    redirect_to root_path
  end
  private
  
    def client_params
      params.require(:client).permit(:name, :phone)
    end

    def correct_user
      @client = Client.find(params[:id])
      redirect_to (root_path) unless @client.user_id == current_user.id
    end
end
