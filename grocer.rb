def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |name, price|
      if new_cart[name].nil?
        new_cart[name] = price.merge({:count => 1})
      else
        new_cart[name][:count] += 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons) 
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += coupon[:num]
      else
        cart["#{item_name} W/COUPON"] = {
          price: coupon[:cost] / coupon[:num],
          clearance: cart[item_name][:clearance],
          count: coupon[:num]
        }
      end
      cart[item_name][:count] -= coupon[:num]
    end
  end
  cart
end 

def apply_clearance(cart)
  cart.each do |item, item_info|
    if item_info[:clearance]
      item_info[:price] = (item_info[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  total_cart = apply_clearance(coupon_cart)

  total = 0
  total_cart.each do |item_name, info|
    total += info[:price] * info[:count]
  end
  total > 100 ? total * 0.9 : total
end
