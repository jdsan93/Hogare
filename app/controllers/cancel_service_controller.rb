class CancelServiceController < ApplicationController
  before_action :set_service
  before_action :authenticate_user!
  before_action :authenticate_information
  before_action :define_user_type
  before_action :correct_user
  
  def cancel
    @service.update_status(0)
    @service.reload
    if !@service.cleaner.nil?
      @service.update(cleaner_id: nil)
    end
    redirect_to service_path(@service)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      puts params
      @service = Service.find(params[:format])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def service_params
      #params.require(:service).permit(:date, :status, :address, :user_id, :worker_id, :price)
    #end

    def define_user_type
      @user = current_user.user_type
    end

    def correct_user
      unless current_user.admin? || 
              current_user.id == @service.order.client.user_id ||         flash[:alert] = "Contenido no disponible"
        redirect_to services_path
      end
    end
end
