def consolidate_cart(cart)
  # code here
  unique_items = {}
  cart.reduce({}) do |memo, hash|
    hash.reduce({}) do |memo, (key, value)|
      if unique_items[key]
        unique_items[key][:count] += 1
      else
        unique_items[key] = value
        unique_items[key][:count] = 1
      end
    end
  end
  return unique_items
end

def apply_coupons(cart, coupons)
  # code here
    cart_with_coupons = cart
    i = 0
    while i < coupons.length do
      use_coupon = nil
      coupons_clearance = nil
      coupons_hash = coupons[i]
      coupons_cost = coupons_hash[:cost]
      coupons_item = coupons_hash[:item]
      coupons_num = coupons_hash[:num]
      item_count = nil
      cart.reduce({}) do |memo, (key, value)|
          item_count = cart_with_coupons[key][:count]
          if coupons_item == key && cart_with_coupons[key][:count] >= coupons_num
            use_coupon = true
            coupons_clearance = cart[key][:clearance]
            cart_with_coupons[key][:count] -= coupons_num 
          end
      end
      if (use_coupon) && (cart_with_coupons["#{coupons_item} W/COUPON"]) && (item_count >= coupons_num)
        cart_with_coupons["#{coupons_item} W/COUPON"][:count] += coupons_num
      elsif use_coupon 
        cart_with_coupons["#{coupons_item} W/COUPON"] = {:price => (coupons_cost/coupons_num), :clearance => coupons_clearance, :count => coupons_num}
      end
      i += 1
    end
  return cart_with_coupons
end

def apply_clearance(cart)
  # code here
  cart.reduce({}) do |memo, (key, value)|
    if cart[key][:clearance] == true
      price = cart[key][:price]
      new_price = (price  * 0.8).round(2)
      cart[key][:price] = new_price
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  final_cart.reduce({}) do |memo, (key, value)|
    total += final_cart[key][:price]*final_cart[key][:count]
  end
  p total > 100 ? (total *= 0.9).round(2) : total
  
end