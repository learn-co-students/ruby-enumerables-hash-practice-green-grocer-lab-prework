require "pry"
def consolidate_cart(cart)
  hash_cart = Hash.new
  cart.each do |item|
    #binding.pry
    hash_cart[item.keys[0]] = item.values[0]
    if hash_cart[item.keys[0]][:count] != nil
      hash_cart[item.keys[0]][:count] += 1
    else
      hash_cart[item.keys[0]][:count] = 1
    end
  end
  hash_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |item|
    if cart[item[:item]] != nil
      disc_num = cart[item[:item]][:count]/item[:num]
      if disc_num != 0
        #binding.pry
        cart[item[:item]][:count] -= disc_num*item[:num]

        cart[item[:item]+" W/COUPON"] = {:price => item[:cost]/item[:num],:clearance => cart[item[:item]][:clearance],:count => disc_num*item[:num]}
      end
      #cart.delete(item[:item]) if cart[item[:item]][:count] == 0
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    #binding.pry
    cart[item][:price] = (0.8*cart[item][:price]).round(2) if cart[item][:clearance]
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.keys.each {|n| total += cart[n][:price]*cart[n][:count]}

  total > 100 ? (0.9*total).round(2) : total
end
