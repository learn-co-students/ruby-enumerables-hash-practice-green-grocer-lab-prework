require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |item, consolidated_cart|
    item.each do |key, value|
      if !consolidated_cart[key]
        consolidated_cart[key] = value
      end
      if !consolidated_cart[key][:count]
        consolidated_cart[key][:count] = 1
      else
        consolidated_cart[key][:count] += 1 
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |item|
    cart_item = cart[item[:item]]
    couponed_item = "#{item[:item]} W/COUPON"
    cart_item_with_coupon = cart[couponed_item]
    #binding.pry
    if cart_item && cart_item[:count] >= item[:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += item[:num]
        cart_item[:count] -= item[:num]
      else
        cart[couponed_item] = {
          :price => item[:cost] / item[:num],
          :clearance => cart_item[:clearance],
          :count => item[:num]
        }
        cart_item[:count] -= item[:num]
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each_value do |value|
    if value[:clearance] == true
      value[:price] = (value[:price]) - (((value[:price]) * (0.2)).round(2))
    end
  end
end

def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(cart_with_coupons)
  #binding.pry
  final_cart.each_value do |value|
    total += (value[:price]) * (value[:count])
  end
  #binding.pry
  if total > 100
    total = (total) - (((total) * (0.1)).round(2))
  end
  return total
end
