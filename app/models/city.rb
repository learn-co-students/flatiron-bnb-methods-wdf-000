class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings #make into hash
    cities = {}
    self.all.each do |city|
      cities[city.name] = (city.reservations.count * 1.0) / city.listings.count
    end
    city = cities.select {|k, v| v == cities.values.max}.keys
    self.find_by(name: city)
  end

  def self.most_res
    cities = {}
    self.all.each do |city|
      cities[city.name] = city.reservations.count
    end
    city = cities.select {|k, v| v == cities.values.max}.keys
    City.find_by(name: city)
  end

  def city_openings(date_1, date_2)
    arr = []
    self.listings.each do |listing|
      avail = true
      listing.reservations.each do |reservation|
        if (reservation.checkin..reservation.checkout).overlaps?(date_1..date_2)
          avail = false
        end
      end
      arr << listing if avail == true
    end
    arr
  end

end
