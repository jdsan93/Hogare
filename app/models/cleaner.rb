class Cleaner < ApplicationRecord
  belongs_to :user
  has_many :services, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }, if: -> { !self.new_record? }
  validates :phone, presence: true, length: { is: 10 }, if:-> { !self.new_record? }
  validates :user_id, presence: true

  def self.available_cleaners(service_date)
    busy_cleaners = Service.where(date: service_date).where.not(cleaner_id: nil).distinct.pluck(:cleaner_id)
    active_cleaner = self.where('start_date <= (?) and end_date > (?)', service_date, service_date)
    active_cleaner.where.not(id: busy_cleaners) 
  end

end
