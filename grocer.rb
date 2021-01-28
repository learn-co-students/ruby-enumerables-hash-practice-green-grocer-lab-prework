def consolidate_cart(cart)
   hash_cart = {}
   cart.each do |food_item|
      food_item.each do |food_name, food_item_info|
        if hash_cart[food_name] == nil
           hash_cart[food_name] = food_item_info
          
           hash_cart[food_name][:count] = 1
           
        else 
           hash_cart[food_name][:count] += 1
            #p "this item is #{hash_cart[food_item]} and info: #{hash_cart[food_item_info]}"
        end
      end
    end
   return hash_cart
end


# code that doesn't work:
def apply_coupons(cart, coupons)
 coupons.each do |coupon|
   coupon.each do |attribute, value|
     
   item_name = coupon[:item]
     if cart[item_name] && cart[item_name][:count] >= coupon[:num]
       if cart["#{item_name} W/COUPON"] == nil
         cart["#{item_name} W/COUPON"] = {:price => (coupon[:cost]/coupon[:num]), :clearance => cart[coupon[:item]][:clearance], :count => coupon[:num]}
         #p cart
        else
          cart["#{item_name} W/COUPON"][:count] += coupon[:num]
          p "there are #{cart["#{item_name} W/COUPON"][:count]} applied"
        end
        cart[item_name][:count] -= coupon[:num]
      end
    end
  end
  cart
end
  
  
  
  

#another way:
#def apply_coupons(cart, coupons)
 # coupons.each do |coupon|
 #   if cart.keys.include?(coupon[:item])
  #    if cart[coupon[:item]][:count] >= coupon[:num]
   #     itemwithCoupon = "#{coupon[:item]} W/COUPON"
    #    if cart[itemwithCoupon]
     #     cart[itemwithCoupon][:count] += coupon[:num]
      #    cart[coupon[:item]][:count] -= coupon[:num]
       # else
        #  cart[itemwithCoupon] = {}
         # cart[itemwithCoupon][:price] = (coupon[:cost] / coupon[:num])
  #        cart[itemwithCoupon][:clearance] = cart[coupon[:item]][:clearance]
   #       cart[itemwithCoupon][:count] = coupon[:num]
    #      cart[coupon[:item]][:count] -= coupon[:num]
     #   end
#      end
 #   end
 # end
#  cart

#end









# why doesn't the below work??
  

# def apply_clearance(cart)
 
# cart.each do |item|
#   item.each do |item_name, info|
  #   if cart[item_name][:clearance] == true 
    #   cart[item_name][:price] = (cart[item_name][:price]*0.80).round(2)  
 #  p  "#This #{cart[item]} is #{cart[item_name][:price]} because #{cart[item_name][:clearance]}"
   #  end
  # end
 #end
 #return cart
#nd



def apply_clearance(cart)
 

cart.each do |item, info|
  if info[:clearance] == true 
      info[:price] = (info[:price]*0.80).round(2)    
     end
 end
 return cart
end







def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)
  consolidated_cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  consolidated_cart_with_coupoins_and_clearance = apply_clearance(consolidated_cart_with_coupons)
  
  
   consolidated_cart_with_coupoins_and_clearance.each do |item, details| 
    total += (consolidated_cart_with_coupoins_and_clearance[item][:count] * consolidated_cart_with_coupoins_and_clearance[item][:price])
    
  end 
 if total > 100
    total = total * 0.9
end
  total

 end

