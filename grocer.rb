require "pry"

cart = [
  {"BEER" => {:price => 13.00, :clearance => false}},
  {"BEER" => {:price => 13.00, :clearance => false}},
  {"BEER" => {:price => 13.00, :clearance => false}}
]

coupons = [{:item => "BEER", :num => 2, :cost => 20.00},
            {:item => "BEER", :num => 2, :cost => 20.00}]

def consolidate_cart(cart)
  cart_hash = {}
  counts = Hash.new(0)
  cart.each { |element| counts[element.keys[0]] += 1}
  cart.each do |e|
    name = e.keys[0]
    cart_hash[name] = e[name].merge({count: counts[name]})
  end
  cart_hash
end


def apply_coupons(cart, coupons)
  coupon_hash = ""
  coupon_name = ""
  i = 0
  while i < coupons.length
    cart.each do |k, v|
      if k == coupons[i][:item] && v[:count] >= coupons[i][:num]
        new_count = cart[k][:count] - coupons[i][:num]
        coupon_name = k + " W/COUPON"
        coupon_hash = {price: coupons[i][:cost], clearance: cart[k][:clearance], count: 1}
        cart[k][:count] = new_count
      end
    end
    if cart.key?(coupon_name)
      cart[coupon_name][:count] += 1
    else
      cart[coupon_name] = coupon_hash
    end
    i += 1
  end #end while
  cart
end

def apply_clearance(cart)
  cart.each do |item, data|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0.0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
binding.pry
  cart.each do |k, v|
    total += v[:price] * v[:count] unless v[:count] == 0
  end
  if total > 100
    total *= 0.9
    return total.round(2)
  else
    return total
  end
end

puts checkout(cart, coupons)
