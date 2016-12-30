class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    available = []
    listings.each do |listing|
      available << listing unless
      listing.reservations.find do |reservation|
        (start_date <= reservation.checkout.to_s) && (end_date >= reservation.checkin.to_s)
      end
    end
    available
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|city| (city.reservations.size)/(city.listings.size)}
  end

  def self.most_res
    self.all.max_by{|city| city.reservations.size}
  end
end
