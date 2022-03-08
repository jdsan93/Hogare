class AddressesController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_information
  before_action :client_user, only: [:new,:create]
  before_action :correct_user, only: [:edit, :update]

  # GET /addresses
  # GET /addresses.json
  def index
    if( current_user.user_type == "admin")
      @addresses = Address.all.page(params[:page]).per(10)
    elsif ( current_user.user_type == "client" )
      @addresses = current_user.addresses.page(params[:page]).per(10)
    else
      redirect_to root_path
    end
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    redirect_to addresses_path
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @client = Client.find_by(user_id: current_user.id)
    @address = Address.new(body: params[:address][:body],client_id: @client.id)

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: 'Su direccion fue guardada!' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      @address.update(address_params)
      if @address.save
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:body, :client_id)
    end

    def client_user
      if current_user.user_type == "admin"
        flash[:alert] = "Contenido no disponible"
        redirect_to addresses_path
      end
    end

    def correct_user
      unless current_user.admin? || 
        current_user.id == @address.client.user_id ||         flash[:alert] = "Contenido no disponible"
        redirect_to services_path
      end
    end
end
