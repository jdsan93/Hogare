class Service < ApplicationRecord
    belongs_to :address
    belongs_to :order
    has_one :client, through: :order, dependent: :nullify
    belongs_to :cleaner, optional: true
    validates :address_id, presence: true
    validates :order_id, presence: true
    validates :price, presence: true

    enum status: {cancelado: 0, pendiente: 1, 
        asignado: 2, completado: 3}

    def self.paid
      joins(:order).where(orders: { order_status: 2 } )
    end

    def self.search(status)
      if !status.blank?
          where("status = (?)", status)
        else
          self.all
      end
    end

    def update_status(new_status)
        self.update(status: new_status) 
    end

    def check_status
        #Si no esta cancelado
        if self.status != 0
          #Si no ha vencido
          if self.date > Date.today
            #Y no tiene trabajador
            if self.cleaner_id.nil?
              update_status(1)
            #Si tiene trabajador
            else
              update_status(2)
            end
          #Si vencio
          else
            #Y no tiene trabajador
            if self.cleaner_id.nil?
              update_status(0)
            #Y si tiene trabajador
            else
              update_status(3)
            end
          end
        end
    end
end
