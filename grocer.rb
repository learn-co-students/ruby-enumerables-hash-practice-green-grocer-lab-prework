def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item_hash|
    item_name = item_hash.keys[0]
    item_info = item_hash.values[0]
    if !cart_hash[item_name]
      cart_hash[item_name] = item_info
      cart_hash[item_name][:count] = 1
    else
      cart_hash[item_name][:count] += 1
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    coupon_name = coupon[:item] + " W/COUPON"
    coupon_count = coupon[:num]
    new_price = coupon[:cost] / coupon_count
    # if the coupon applies
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon_count
        cart[coupon[:item]][:count] -= coupon_count
        if !cart[coupon_name]
          cart[coupon_name] = {
            :price => new_price,
            :clearance => cart[coupon[:item]][:clearance],
            :count => coupon_count
          }
        else
          cart[coupon_name][:count] += coupon_count
        end
      end
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each do |item_name, info_hash|
    clearance_status = info_hash[:clearance]
    if clearance_status
      info_hash[:price] -= (info_hash[:price] * 0.2).round(2)
    end
  end
  cart
end

def total(cart)
  total = 0
  cart.each do |item_name, info_hash|
    price = info_hash[:price]
    count = info_hash[:count]
    total += ( price * count )
  end
  total
end

def ten_off_total(cart_total)
  new_total = (cart_total * 0.9).round
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart) #should be ok
  discounted = apply_coupons(consolidated, coupons) #should return unchanged cart
  double_discounted = apply_clearance(discounted)
  grand_total = total(double_discounted)
  if grand_total > 100
    grand_total = ten_off_total(grand_total)
  end
  grand_total
end
