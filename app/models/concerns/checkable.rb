module Checkable

  module ClassMethods

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

    # do class methods only work with other class methods?
    def reservations(location)
      location.listings.collect do |listing|
        listing.reservations.count if listing.reservations
      end.reduce(:+)
    end

  end # ./ClassMethods end

  module InstanceMethods
    # reservation_check returns an array
    # it checks for overlaping dates of a particular listings reservations using input dates
    # returns a collection of matching reservations or nil values if they didnt match
    # NOTE: Can this method be refactored for clarity?
    def reservation_check(listing, start_date, end_date)
      listing.reservations.collect do |reservation|
        reservation if (Date.parse(start_date) <= reservation.checkout) and (Date.parse(end_date) >= reservation.checkin)
      end
    end

  end # ./InstanceMethods end

end