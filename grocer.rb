def consolidate_cart(cart)
  consolidated_cart = {} 
    cart.each do |food_list| 
      food_list.each do |food, characteristics|
        if consolidated_cart[food]
          consolidated_cart[food][:count] += 1
        else 
          consolidated_cart[food] = characteristics
          consolidated_cart[food][:count] = 1 
        end
      end 
    end 
    consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        name = "#{coupon[:item]} W/COUPON"
        if cart[name]
          cart[name][:count] += coupon[:num]
        else 
          cart[name] = {
            count: coupon[:num],
            price: coupon[:cost] / coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end	

def apply_clearance(cart)
  cart.keys.each do |list_of_groceries|
    if cart[list_of_groceries][:clearance]
      cart[list_of_groceries][:price] = (cart[list_of_groceries][:price] * 0.8).round(2)
    end
  end
  cart
end	

def checkout(cart, coupons)
  non_discounted_cart = consolidate_cart(cart) 
  cart_after_coupons = apply_coupons(non_discounted_cart, coupons) 
  final_cart = apply_clearance(cart_after_coupons) 
  total = 0 
  
  final_cart.each do |name, characteristics|
    total += characteristics[:price] * characteristics[:count] 
  end
  
  total = total * 0.9 if total > 100 
  total
end 