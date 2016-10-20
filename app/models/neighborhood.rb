class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(arrive,leave)
    available = []
    self.listings.each do |listing|
      # If all the reservation do not overlap with the date range from the params we add it
      available << listing if listing.reservations.all? do |reservation|
        !(arrive..leave).overlaps?(reservation.checkin.to_s..reservation.checkout.to_s)
      end
    end
    available
  end

  def self.most_res
    all.max_by{|neighborhood| neighborhood.reservations.count }
  end

  def self.highest_ratio_res_to_listings

    all.max_by do |neighborhood|
      if neighborhood.reservations.count > 0 && neighborhood.listings.count > 0
        (neighborhood.reservations.count)/(neighborhood.listings.count)
      else
        0
      end
    end
  end

end
