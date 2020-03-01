def consolidate_cart(cart)
  list = {}
  cart.each do |item|
    item.each do |key, value|
      if list[key]
        list[key][:count] += 1 
      else  
        list[key] = value
        list[key][:count] = 1 
      end
    end
  end
    return list
end

def apply_coupons(cart, coupons)
  coupons.each do |val|
    if cart[val[:item]]
      if cart[val[:item]][:count] >= val[:num]
        cart[val[:item]][:count] -= val[:num]
        new_name = val[:item] + " W/COUPON"
        cart[new_name] = {:price => val[:cost]/val[:num], :clearance => cart[val[:item]][:clearance], :count => val[:num]}
        while cart[val[:item]][:count] >= val[:num] do 
          cart[new_name][:count] += val[:num]
          cart[val[:item]][:count] -= val[:num]
        end
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if cart[key][:clearance] == TRUE
      cart[key][:price] = cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end 
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_price = 0 
  cart.each do |key, value|
    total_price += cart[key][:price] * cart[key][:count]
  end
  if total_price >= 100
    total_price *= 0.9
  end
  return total_price
end
