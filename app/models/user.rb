class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :add_to_corresponding_table
  
  has_many :clients, dependent: :destroy
  has_many :admins, dependent: :destroy
  has_many :cleaners, dependent: :destroy
  has_many :addresses, through: :clients
  has_many :orders, through: :clients

  enum user_type: {admin: 0,client: 1, cleaner: 2}
  default_scope {order(created_at: 'desc')}


  def self.search(email)
    if !email.blank?
      where("email LIKE (?)", "%#{email}%")
    else
        self.all
    end
  end
 
  private
    
    def add_to_corresponding_table
      if self.user_type == "client"
        Client.create!(user_id: self.id)
      elsif self.user_type == "admin"
        Admin.create!(user_id: self.id)
      else
        Cleaner.create!(user_id: self.id)
      end
    end
end
