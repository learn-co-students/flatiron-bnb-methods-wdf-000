require 'pry'

module Ratio

  module ClassMetods

    def highest_ratio_res_to_listings
      ratio = {}
       self.all.each do |i|
       if i.listings.size != 0
         ratio[i] = (i.reservations.size.to_f / i.listings.size.to_f)
       end
      end
      ratio.max_by{|k, v| v}.first
    end

    def most_res
      self.all.max{|a, b| a.reservations.size <=> b.reservations.size}
    end

  end

end
