json.extract! order, :id, :total_price, :user_id, :admin_id, :order_status, :created_at, :updated_at
json.url order_url(order, format: :json)
