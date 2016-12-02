module Concerns
  module InstanceMethods
    def openings(checkin, checkout)
      range1 = Date.parse(checkin)
      range2 = Date.parse(checkout)
      requested_range = range1..range2
      arr =[]
      self.listings.each do |listing|
        tmp = false
        listing.reservations.each do |reservation|
          unavailable_range = reservation.checkin..reservation.checkout
          if unavailable_range.overlaps?(requested_range)
            tmp = true
          end
        end
        arr << listing unless tmp
      end
    end

    def city_openings(checkin, checkout)
      openings(checkin, checkout)
    end

    def neighborhood_openings(checkin, checkout)
      openings(checkin, checkout)
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      hash = Hash[all.map { |x| [x, x.reservations.size/x.listings.size.to_f] }]
      hash.each do |k, v| 
        hash[k] = 0 if v.nan?
      end
      hash.sort_by{ |k, v| v }.to_h.keys.last
    end

    def most_res
      hash = Hash[all.map { |x| [x, x.reservations.size]}]
      hash.sort_by{ |k, v| v }.to_h.keys.last
    end
  end
end
