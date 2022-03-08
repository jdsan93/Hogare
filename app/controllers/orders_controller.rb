class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :authenticate_information
  before_action :validation_presence_address, if: -> { current_user.user_type == 'client' }
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_addresses, only: [:edit, :update]
  before_action :correct_user_type, only: [:update]

  # GET /orders
  # GET /orders.json
  def index
    if current_user.user_type == "admin"
      search_status = params[:search_status]
      @orders = Order.search(search_status).page(params[:page]).per(5)
    elsif current_user.user_type == "client"
      @orders = current_user.orders.page(params[:page]).per(5)
    else
      redirect_to root_path
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if !current_user.client?
      redirect_to orders_path
    end
  end

  # GET /orders/1/edit
  def edit
    redirect_to orders_path
  end

  # POST /orders
  # POST /orders.json
  def create
    @dates = params[:dates]
    number_of_dates = @dates.split(",").count
    if @dates.blank?
      flash[:alert] = "Por favor introduzca por lo menos una fecha"
      redirect_to  new_order_path
      return
    elsif number_of_dates > 30
      flash[:alert] = "El máximo de fechas son 30 por orden"
      redirect_to  new_order_path
      return
    end
    begin
      @dates.split(",").each do |date|
        date = date.strip
        m, d, y = date.split("/")
        if Date.strptime(date,'%m/%d/%y').class != Date.today.class || d.length > 2 || m.length > 2 || y.length > 4
          flash[:alert] = "Fecha inválida"
          redirect_to  new_order_path
          return
        end
      end
    rescue ArgumentError
      flash[:alert] = "Fecha inválida"
      redirect_to  new_order_path
      return
    end
    client_id = current_user.clients.ids.first
    @order = current_user.orders.new(client_id: client_id)
  
      if @order.save
        @order.update_total_price(@dates.split(",").count)
        redirect_to new_service_path(dates: @dates, order_id: @order.id), notice: 'Orden creada satisfactoriamente'
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end

  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
        order_status = params[:status]
        
      if @order.update(order_status: "#{order_status}")
        redirect_to orders_path, notice: 'La order se actualizo exitosamente.' 
      else
        redirect_to orders_path, notice: 'error prueba de nuevo' 
      end

  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_addresses
      @addresses = current_user.addresses.pluck(:body,:id).to_h
    end

    def correct_user_type
      unless current_user.admin? || current_user.client?
        flash[:alert] = "Contenido no disponible"
        redirect_to services_path
      end
    end

    def validation_presence_address
      client = Client.find_by(user_id: current_user.id)
      address = Address.find_by(client_id: client.id) 
      redirect_to (new_address_path), flash: { notice: "Por favor registre una dirección" } unless address.present?
    end
end
