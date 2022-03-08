class Admin < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }, if: -> { !self.new_record? }
  validates :phone, presence: true, length: { is: 10 }, if:-> { !self.new_record? }
  validates :user_id, presence: true

end
