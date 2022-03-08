class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update]
  before_action :set_addresses, only: [:new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_information
  before_action :correct_user, only:[:show, :edit, :update]
  before_action :change_status_services, only: [:index]
  

  # GET /services
  # GET /services.json
  def index
    name = params[:search_name]
    email = params[:search_email]
    status = params[:search_status]

    if current_user.user_type == "admin"
      @services = Service.all.search(status).order(date: :desc).page(params[:page]).per(30)
    elsif current_user.user_type == "cleaner"
      @services = current_user.cleaners.first.services.order(:date).page(params[:page]).per(30)
    else #if == client
      @services = current_user.clients.first.services.page(params[:page]).per(30) 
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    redirect_to services_path
  end

  # GET /services/new
  def new
    if current_user.client?
      @order_id = params[:order_id]
      @dates = params[:dates].split(",")
      @price = @dates.count * 55000    
      @service = Service.new
    else
      redirect_to services_path
    end
  end

  # GET /services/1/edit
  def edit
    if @service.cancelado? || @service.completado? || !current_user.admin?
      redirect_to services_path
    else
      @client = @service.client
      @cleaner = @service.cleaner
      cleaners_object = Cleaner.available_cleaners(@service.date)
      @cleaners = cleaners_object.pluck(:name,:id).to_h
    end
  end

  # POST /services
  # POST /services.json
  def create

    order_id = params[:order_id].to_i
    num_dates = params[:num_dates].to_i
    
    dates = (0...num_dates).map {|date| params["date_#{date}"]}
    only_addresses = (0...num_dates).map {|address| params["address_#{address}"]}
    addresses_ids = only_addresses.map {|address| @addresses[address]}
    
    new_service = dates.zip(addresses_ids).to_h

    new_service.each do |date,address|
      date = Date.strptime(date,'%m/%d/%Y')
      @service = Service.create!(date: date, price: 55000, address_id: address, order_id: order_id)

        if !@service.save
          redirect_to new_service_path, notice: 'Ha ocurrido un error'
        end

    end
    UserMailer.orders(@service.order).deliver_now
    redirect_to orders_path, notice: 'Sus servicios han sido solicitados exitosamente, por favor revise su correo para ver la factura'
  end


  def update
    date = params[:service][:date]
    cleaner_id = params[:cleaner_id]
      if @service.update(date: date, cleaner_id: cleaner_id)
          @service.check_status
        redirect_to order_path(@service.order.id), notice: 'Servicio actualizado.'
      else
        redirect_to services_path, notice: 'error.'
      end
  end


  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def service_params
    #  params.require(:service).permit(:date, :status, :address_id, :order_id, :cleaner_id, :price)
    #end

    def set_addresses
      @addresses = current_user.addresses.pluck(:body,:id).to_h
    end

    def correct_user
      unless current_user.user_type == "admin" || 
              current_user.id == @service.order.client.user.id
        flash[:alert] = "Contenido no disponible"
        redirect_to services_path
      end
    end

    def change_status_services
      services = Service.where("date <= ?", Date.today).where(status: ["asignado", "pendiente"])
        services.each do |service|
          if service.status == "asignado" && service.date < Date.today
            service.update(status: 3.to_i) 
          elsif service.status == "pendiente" && service.date <= Date.today
            service.update(status: 0.to_i)
          end
        end
    end

end
