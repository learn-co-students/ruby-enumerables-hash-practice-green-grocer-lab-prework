require "pry" 

def consolidate_cart(cart)
  new = {}
  cart.each_with_index do |item|
    item.each do |food, info|
      if new[food]
        new[food][:count] += 1
      else
        new[food] = info
        new[food][:count] = 1
      end
    end
  end
  new
end

def apply_coupons(cart, coupons)
   coupons.each do |sale| # loops over each item within the coupon hash 
      if cart.keys.include?(sale[:item]) #check if a coupon applies to something in the cart 
          if cart[sale[:item]][:count] >= sale[:num]   
          cart[sale[:item]][:count] -= sale[:num]
              new_key = "#{sale[:item]} W/COUPON" 
                if cart.keys.include?(new_key)
                  cart[new_key][:count] += sale[:num]
                  else 
                    cart[new_key] = {:price => sale[:cost] / sale[:num], :clearance => cart[sale[:item]][:clearance], :count => sale[:num]}
                    
        end 
      end
     end
  end 
  cart 
end 

def apply_clearance(cart)
   cart.each do |item, info|
  if info[:clearance] 
      (info[:price] = info[:price] * 0.8)
      info[:price] = info[:price].round(2)  
 end  
 end 
 cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart) #calls method 
  cart_with_coupons = apply_coupons(new_cart, coupons) #calls method with totals from first method 
  final_cart_list = apply_clearance(cart_with_coupons) #calls method with totals from first method and coupons from second 
  total = 0 #sets total price of the stuff in the cart to zero 
  final_cart_list.each do |name, info| # name- items in cart, properties- :price, :clearance, :count 
    total += info[:price] * info[:count] #figures out how much per item and how many exist in the cart 
    # for both regular-priced and couponded items 
  end
  total = total * 0.9 if total > 100 #applies final discount 
  total
end