class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  

  def city_openings(start_date, end_date)
    listings.find_all { |l| l.available?(start_date, end_date) }
  end

  def self.highest_ratio_res_to_listings
    all.max_by {|city| (city.reservations.count)/(city.listings.count)}
  end

  def self.most_res
    all.max_by {|city| city.reservations.count}
  end
end

