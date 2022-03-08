class Address < ApplicationRecord
  belongs_to :client
  has_many :services, dependent: :nullify
  validates :client_id, presence: true
  validates :body, presence: true, length: { maximum: 255 }

end
