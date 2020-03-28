def consolidate_cart(cart)
 new_cart = {}
 cart.each do |items|
    items.each do |item, item_info|
     if new_cart[item]
      new_cart[item][:count] += 1
     else
       new_cart[item] = item_info
       new_cart[item][:count] = 1
      end
    end
  end
 new_cart
end

def apply_coupons(cart, coupons)
  result = {}
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += coupon[:num]
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost] / coupon[:num], :clearance => info[:clearance], :count => coupon[:num]}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart)
  cart.each do |item, attribute_hash| 
    if attribute_hash[:clearance] == true 
      attribute_hash[:price] = (attribute_hash[:price] *
      0.8).round(2) 
    end 
  end 
cart 
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(new_cart,coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0
  final_cart.each do |item_name, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end
  
  if total >= 100
    total *= 0.9
  end
  
  total
end
