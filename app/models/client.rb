class Client < ApplicationRecord
  has_many :address, dependent: :destroy 
  has_many :orders, dependent: :nullify
  has_many :services, through: :orders
  belongs_to :user

  validates :name, presence: true, length: { maximum: 50 }, if: -> { !self.new_record? }
  validates :phone, presence: true, length: { is: 10 }, if:-> { !self.new_record? } 
  validates :user_id, presence: true

end
