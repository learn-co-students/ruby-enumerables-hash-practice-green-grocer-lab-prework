def consolidate_cart(cart)
  organized_cart = {}
  cart.each do |item|
    item.each do |key, value|
      if organized_cart[key]
        organized_cart[key][:count] += 1
      else
        organized_cart[key] = value
        organized_cart[key][:count] = 1
      end
    end
  end
  organized_cart
end

def apply_coupons(cart, coupons)
  coupon_hash = {}
  coupons.each{ |k, v| coupon_hash[k] = v}
  temp_hash = {}
  cart.each do |k, v| 
    coupon_hash.each do |k2, v2|
      if k2[:item] == k
        if v[:count] >= k2[:num]
          temp_count = v[:count] / k2[:num]
          cou_count = temp_count * k2[:num]
          v[:count] = v[:count] - cou_count
          temp_hash["#{k} W/COUPON"] = {
            :price => k2[:cost] / k2[:num],
            :clearance => v[:clearance],
            :count => cou_count
          }
        end
      end
    end
  end
  return_hash = cart.merge(temp_hash)
  return_hash
end

def apply_clearance(cart)
  cart.each do |k, v|
    if v[:clearance]
      v[:price] = (v[:price] - (v[:price] * 0.20))
    end
  end
  cart
end

def checkout(cart, coupons)
  shiney_cart = consolidate_cart(cart)
  discounts_applied = apply_coupons(shiney_cart, coupons)
  final_cart = apply_clearance(discounts_applied)
  total = 0
  final_cart.each do |k, v|
    total += v[:price] * v[:count]
  end
  if total > 100
    total = (total - (total * 0.10))
  end
  total
end
