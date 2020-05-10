     #{"AVOCADO"=>{:price=>3.0, :clearance=>true}}

def consolidate_cart(cart) #define method and arguments
  hash = {} #create an empty hash
  cart.each do |item| #iterating through each item in cart array 
    if hash[item.keys[0]] #if item matches value "AVOCADO"
      hash[item.keys[0]][:count] +=1 #add 1 to the :count
    else #if item does not match first key
      hash[item.keys[0]] = item[item.keys[0]] #the first key in the hash is equal to the item
      hash[item.keys[0]][:count] = 1 #:count = 1
    end #close if statement
  end #close do...end
  hash
end #close method
  
def apply_coupons(cart, coupons) #define methods and arguments
  coupons.each do |coupon| #iterating through each item in coupons array
    if cart[coupon[:item]] && cart[coupon[:item]][:count] >= coupon[:num] #if item in cart matches coupon
      item_coupon_name = coupon[:item] + " W/COUPON" #assign new name
      if cart[item_coupon_name]
        cart[item_coupon_name][:count] += coupon[:num]
        cart[coupon[:item]][:count] =  cart[coupon[:item]][:count] - coupon[:num]
      else
        price_with_coupon = coupon[:cost]/coupon[:num]
        cart[item_coupon_name] = {:price => price_with_coupon,
                                  :count => coupon[:num],
                                  :clearance => cart[coupon[:item]][:clearance]}
        cart[coupon[:item]][:count] =  cart[coupon[:item]][:count] - coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item|
    if item[1][:clearance]
      clearance_price = item[1][:price] * 0.8
      cart[item[0]][:price] = clearance_price.round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  organized_cart = consolidate_cart(cart)
  puts organized_cart
  applied_coupons_cart = apply_coupons(organized_cart, coupons)
  puts applied_coupons_cart
  final_cart = apply_clearance(applied_coupons_cart)
  
  final_cost = 0
  final_cart.each do |item|
    final_cost += item[1][:price]*item[1][:count]
  end
  
  if final_cost > 100
    final_cost = (final_cost * 0.9).round(2)
  end
  final_cost
end
