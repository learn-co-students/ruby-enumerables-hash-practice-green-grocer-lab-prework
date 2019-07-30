def consolidate_cart(cart)
  # code here
  consolidated_cart = {}
  cart.each do |item|
    if consolidated_cart[item.keys[0]]
      consolidated_cart[item.keys[0]][:count] += 1
    else
      consolidated_cart[item.keys[0]] = {
        count: 1,
        price: item.values[0][:price],
        clearance: item.values[0][:clearance]
      }
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= [:num]
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
  # code here
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = cart[item][:price] * 0.8
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  
end
