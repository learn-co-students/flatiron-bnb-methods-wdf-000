module Reservable
   extend ActiveSupport::Concern

  def openings(checkin, checkout)
    self.listings.each do |listing|
      listing.reservations.find do |reservation|
        if reservation.checkin.to_s > checkin || reservation.checkout.to_s < checkout
          reservation.listing
        end
      end
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

    def highest_ratio_reservations_to_listings

      all.max do |a, b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end

    def most_reservations
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end
end
