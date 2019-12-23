def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item_data|
    item_data.each do |item, details|
      if consolidated_cart.keys.include?(item)
        consolidated_cart[item][:count] += 1
      else
        consolidated_cart[item] = details
        consolidated_cart[item][:count] = 1
      end
    end
  end
end 

def apply_coupons(cart, coupons)
 coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
        new_item = "#{coupon[:item]} W/COUPON"
        if cart.keys.include?(new_item)
          cart[new_item][:count] += 1
        else
          cart[new_item] = {:price => coupon[:cost], :count => 1, :clearance => cart[coupon[:item]][:clearance]}
        end
      end
    end
  end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] = (details[:price] * 0.8).round(2)
    end
  end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  cost = 0.0

   applied_clearance.each do |item, details|
    cost += (details[:price] * details[:count])
  end

   if cost > 100.0
    cost = cost * 0.90
  end
