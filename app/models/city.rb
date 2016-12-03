class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings



  def city_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.select do |reservation|
        reservation.checkout.to_s < start_date && reservation.checkin.to_s > end_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by{|city| (city.reservations.count)/(city.listings.count)}

  end

  def self.most_res
    City.all.max_by{|city| city.reservations.count}
  end
end
