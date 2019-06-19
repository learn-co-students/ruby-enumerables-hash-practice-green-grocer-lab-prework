def consolidate_cart(cart)
  # create an empty hash to store combined cart
  combined_cart = {}
  # iterate each item in cart
  cart.each do |item|
    # store key and values in variables
    item_type = item.keys[0] # using [0] stores as string
    item_values = item.values[0] # using [0] stores as hash
    # if item already  in cart, increment count
    if combined_cart[item_type]
      combined_cart[item_type][:count] += 1
    # if item not in cart, store values in new key and add 'count' key-value pair
    else
      combined_cart[item_type] = item_values
      combined_cart[item_type][:count] = 1
    end
  end
  combined_cart
end

def apply_coupons(cart, coupons = false)
  # are there coupons?
  if coupons
    # loop over each coupon in set
    coupons.each do |coupon|
      # store item type, number of items required by coupon, and per-item price in variables
      item = coupon[:item]
      coupon_num = coupon[:num]
      per_item_price = coupon[:cost] / coupon_num
      # is the coupon item in the cart with enough to apply the coupon?
      if cart[item] && cart[item][:count] >= coupon_num
        coupon_item = "#{item} W/COUPON"
        # increase the count by the coupon item number, creating the coupon item if it doesn't already exist
        if cart[coupon_item]
          cart[coupon_item][:count] += coupon_num
        else
          cart[coupon_item] = {
            price: per_item_price,
            clearance: cart[item][:clearance],
            count: coupon_num
          }
        end
        # if items have been couponed, deduct that from the normal amount
        cart[item][:count] -= coupon_num
      end
    end
  end
  # return new cart
  cart
end

def apply_clearance(cart)
  # check each cart item to see if it's on clearance
  cart.each_key do |item|
    if cart[item][:clearance]
      # if so, discount by 20%
      clearance_price = cart[item][:price] * 0.8
      cart[item][:price] = clearance_price.round(2)
    end
  end
  # return new cart
  cart
end

def checkout(cart, coupons = false)
  # create variable to store final cost
  final_cost = 0.0
  # run each variable in succession, passing results into next step
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  # add together the final cost of each item in the cart
  final_cart.each_key do |item|
    final_cost += (final_cart[item][:price] * final_cart[item][:count])
  end
  # apply discount if over $100.00
  if final_cost > 100.0
    final_cost *= 0.9
  end
  # return final cost
  final_cost
end
