# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker' 

password = "foobar"
#Cleaners
100.times do|c|
  email = "example-cleaner-#{c+1}@email.com"
  
  user_type = 2
  #created_at = 4.month.ago + c.days
  user = User.create!(email: email, password: password, user_type: user_type)

  name = "Nombre Cleaner #{c+1}"
  phone = 2222222222+c
  start_date = 1.month.ago - 2.weeks + c.days
  end_date = start_date + 2.weeks
  cleaner = Cleaner.find_by(user_id: user.id)
  cleaner.update(name: name, phone: phone, start_date: start_date, 
                  end_date: end_date)
end

11.times do |n|

  #Admins
  if n<4
    email = "example-admin-#{n+1}@email.com"
    name = "Nombre Admin #{n+1}"
    phone = 0000000000+n
    
    user_type = 0
    user = User.create!(email: email, password: password, user_type: user_type)
    admin = Admin.find_by(user_id: user.id)

    admin.update(name: name, phone: phone)
  elsif n<9

    #Clients
    email = "example-#{n+1}@email.com"
    
    user = User.create!(email: email, password: password)

    name = "Nombre Cliente #{n+1}"
    phone = 1111111111+n
    client = Client.find_by(user_id: user.id)
    client.update(name: name, phone: phone, user_id: user.id)
    
    #Addresses
    2.times do |a|
      body = "Calle #{a+1}"
      address = Address.create!(body: body, client_id: client.id)
    end

    #Orders
    total_price = 0
    order_status = 1
    order = Order.create!(total_price: total_price, order_status: order_status, client_id: client.id)
    if n%2 == 0
      #Services pending
      5.times do |s|
        date = 2.weeks.ago + s.weeks
        status = 1
        price = 55000
        address = Address.find_by(client_id: client.id)
        service = Service.create!(date: date, status: status, price: price, address_id: address.id, order_id: order.id)
        
        total_price = total_price + price

      end
      order.update(total_price: total_price)
    else
      #Services assigned
      5.times do |s|
        date = 2.weeks.ago + s.weeks
        status = 2
        cleaner_id = s+1
        price = 55
        address = Address.find_by(client_id: client.id)
        service = Service.create!(date: date, status: status, price: price, address_id: address.id, order_id: order.id,cleaner_id: cleaner_id)

        total_price = total_price + price
      end
      admin = Admin.find((1..4).to_a.shuffle.first)
      order_status = 2
      order.update(admin_id: admin.id, order_status: order_status, total_price: total_price)
    end
  else
    #Clients
    email = "example-#{n+1}@email.com"
  
    user = User.create!(email: email, password: password)

    name = "Nombre Cleaner #{n+1}"
    phone = 1111111111+n
    client = Client.find_by(user_id: user.id)
    client.update(name: name, phone: phone, user_id: user.id)

    #Addresses
    2.times do |a|
      body = "Calle #{a+1}"
      address = Address.create!(body: body, client_id: client.id)
    end

    #Orders
    total_price = 0
    order_status = 1
    order = Order.create!(total_price: total_price, order_status: order_status, client_id: client.id)
      #Services assigned
      5.times do |s|
        date = 2.weeks.ago + s.weeks
        status = 1
        cleaner_id = nil
        price = 55
        address = Address.find_by(client_id: client.id)
        service = Service.create!(date: date, status: status, price: price, address_id: address.id, order_id: order.id,cleaner_id: cleaner_id)

        total_price = total_price + price
      end
      admin = nil
      order_status = 2
      order.update(admin_id: admin, order_status: order_status, total_price: total_price)
    end
  end
