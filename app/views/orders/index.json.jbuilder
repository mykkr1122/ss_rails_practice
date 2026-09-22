json.orders @orders do |order|
  json.id order.id
  json.status order.status
  json.total_price order.total_price
  json.created_at order.created_at
end
