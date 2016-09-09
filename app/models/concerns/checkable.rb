module Checkable

  module InstanceMethods

    def reservation_check(listing, start_date, end_date)
      listing.reservations.collect do |r|
        r if (Date.parse(start_date) <= r.checkout) and (Date.parse(end_date) >= r.checkin)
      end
    end
    
  end

end