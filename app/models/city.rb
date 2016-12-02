class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    listings.select do |l|
      l.reservations.where("checkout < #{start_date} && checkin > #{end_date}")
    end
  end

  def self.highest_ratio_res_to_listings
    all.max_by { |city| city.res_to_listings }
  end

  def self.most_res
    all.max_by { |city| city.reservations.count }
  end

  def res_to_listings
    return 0 if listings.count == 0
    reservations.count.to_f / listings.count
  end
end
