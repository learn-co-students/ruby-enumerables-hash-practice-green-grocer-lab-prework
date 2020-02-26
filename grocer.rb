def consolidate_cart(cart)
  consolidated = Hash.new() 
  
  cart.each {|primary_hash|
    primary_hash.each do |k, v|
      if consolidated[k]
        consolidated[k][:count] += 1 
      else 
        consolidated[k] = v 
        consolidated[k][:count] = 1 
      end 
    end 
  }
  
  consolidated
end

def apply_coupons(cart, coupons)
  
  coupons.each do |coupon|
    item = coupon[:item]
    if cart.has_key?(item) && !cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"] = {price: coupon[:cost]/coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
      cart[item][:count] -= coupon[:num]
    elsif cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
  
end

def apply_clearance(cart)
  cart.map do |k, hash|
    if cart[k][:clearance] 
      cart[k][:price] = (cart[k][:price]*0.80).round(2)
    end 
  end 
  cart 
end

def checkout(cart, coupons)
  
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  clearance_applied = apply_clearance(coupons_applied) 
  
  total = 0
  
  clearance_applied.map do |k, hash|
     
    total += (clearance_applied[k][:price]*clearance_applied[k][:count])
    
  end 
  
  if total > 100 
    total *= 0.90
    return total.round(2)
  end 
  
  total
  
end
