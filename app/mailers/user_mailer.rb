class UserMailer < ApplicationMailer

  def orders(order)
    @order = order
    client = order.client
    @client = client
    mail to: client.user.email, subject: "Factura de la orden para los servicios hogare"
  end
end
