module Checkable

  module ClassMethods
    def reservations(location)
      location.listings.collect {|listing| listing.reservations.count}.reduce(:+)
    end

    def highest_ratio_res_to_listings
      ratios = {}
      self.all.each do |location|
        unless location.listings.count == 0
          ratios[location] = reservations(location).to_f / location.listings.count
        end
      end
      ratios.max_by {|k, v| v }.first
    end

    def most_res
      res_hash = {}
      self.all.each do |location|
        res_hash[location] = reservations(location) unless location.listings.empty?
      end
      res_hash.max_by {|k,v| v}.first
    end
  end

  module InstanceMethods
    def reservation_check(listing, start_date, end_date)
      listing.reservations.collect do |r|
        r if (Date.parse(start_date) <= r.checkout) and (Date.parse(end_date) >= r.checkin)
      end
    end
  end
 
end
