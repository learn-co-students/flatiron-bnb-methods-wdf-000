class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date0, date1)
    listings.select do |listing|
      if listing.reservations
        overlaps = listing.reservations.select do |res|
          !(res.checkout < Date.parse(date0) || res.checkin > Date.parse(date1))
        end
      end
      overlaps.empty?
    end
  end

  def self.highest_ratio_res_to_listings
    ratios = all.map{|city| city.city_reservations.to_f / city.listings.count}
    all[ratios.index(ratios.max)]
  end

  def self.most_res
    reservations = all.map{|city| city.city_reservations}
    all[reservations.index(reservations.max)]
  end

  def city_reservations
    self.listings.map{|listing| listing.reservations.count}.inject(0, :+)
  end

end
