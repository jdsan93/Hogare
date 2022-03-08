class Order < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :client
  has_many :services, dependent: :nullify
  after_update :cancel_dependent_services
  validates :client_id, presence: true

  enum order_status: {cancelado: 0, pendiente: 1, 
                      pagado: 2}


  SERVICES_PRICE = 55000
  def self.search(order_status)
    if order_status == "0" || order_status == "1" || order_status == "2"
      where("order_status = (?)", order_status)
    elsif order_status == "-1"
      where(order_status: 2).joins(:services).where(services: {status: 1}).distinct;
    else
      self.all
    end
  end

  def send_order_email
    UserMailer.orders(self).deliver_now
  end

  def update_total_price(total_services)
    total_price = total_services * SERVICES_PRICE
    self.update(total_price: total_price)
  end

  def cancel_dependent_services
    self.services.update(status: 0) if self.cancelado?
  end
end
