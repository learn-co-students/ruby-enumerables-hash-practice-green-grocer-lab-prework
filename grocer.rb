require "pry"

def consolidate_cart(cart)
  cart_hash = {}

    cart.each do |item_hash|

        item_hash.each do |key, value|

          if cart_hash.key?(key)
            cart_hash[key][:count] += 1
          else
            cart_hash[key] = value
            cart_hash[key][:count] = 1
          end
        end
    end
  cart_hash
end


def apply_coupons(cart, coupons)
  
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count] >= coupon[:num]  
      
      if cart["#{item} W/COUPON"]
         cart["#{item} W/COUPON"][:count] += coupon[:num]
        
      else 
          cart["#{item} W/COUPON"] = { 
            price: coupon[:cost] / coupon[:num],
            clearance: cart[item][:clearance],
            count: coupon[:num]
          }
      end
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart)
   
    cart.each do |item_name, values|
        
      if values[:clearance] 
        original_price = values[:price].round(2)
        discount_rate = 0.20.round(2)
        discount_amount = (discount_rate * original_price).round(2)
        
        new_discounted_price = (original_price - discount_amount).round(2)
        values[:price] = new_discounted_price.round(2)
      end
    end
end

def checkout(cart, coupons)
  
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(applied_coupons)
  
  cart_total = 0

     final_cart.each do |item_name, value|
        cart_total += value[:price] * value[:count]
    end

  cart_total > 100 ? (cart_total * 0.90) : cart_total # This is the short way! Refactor of below:
  
  # This is the long way!
  # if cart_total > 100.00
  #   apply_discount = cart_total * 0.10
  #   discounted_cart_total = cart_total - apply_discount
  #   cart_total = discounted_cart_total
  # end
  #cart_total
end 