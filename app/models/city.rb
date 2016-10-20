class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(arrive,leave)
    available = []
    self.listings.each do |listing|
      # If all the reservation do not overlap with the date range from the params we add it
      available << listing if listing.reservations.all? do |reservation|
        !(arrive..leave).overlaps?(reservation.checkin.to_s..reservation.checkout.to_s)
      end
    end
    available
  end

  def self.highest_ratio_res_to_listings
    all.max_by{|city| (city.reservations.count)/(city.listings.count)}
  end

  def self.most_res
    all.max_by{|city| city.reservations.count }
  end

end
