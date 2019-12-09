def consolidate_cart(cart)
  #create a new "consolidate" cart
  new_cart = {}
  #iterate through cart and convert to hash
  cart.each do |hash|
    hash.each do |name,describe|#name: AVOCADO, KALE. #describe: price, clearance
      if new_cart[name] #if the new_cart already has a name and count
        new_cart[name][:count] += 1 #increase the count by 1
      else #if cart is empty / does not contain item
        new_cart[name]=describe #set name as key and describe as value
        new_cart[name][:count] = 1 #create and set count value to 1 (first item occurance)
      end
    end
  end
  new_cart #return the new_cart 
end

def apply_coupons(cart, coupons)
coupons.each do |coupon|
  name = coupon[:item] #makes things easier

  if cart[name] && cart[name][:count] >= coupon[:num]
    if cart["#{name} W/COUPON"]
      cart["#{name} W/COUPON"][:count] += coupon[:num]
    else
      cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[name][:clearance], :count => coupon[:num]}
    end
  cart[name][:count] -= coupon[:num]
  end
end
cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true 
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  total = 0 
  new_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(new_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  clearance_cart.each do |item, info|
    total += (info[:price] * info[:count])
  end

#additional discount if over 100
if total > 100
  total = (total * 0.9).round(2)
else
  total
end
  
end
