class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(l1,l2)
    listings.select do |x|
      x.reservations.where("checkout < #{l1} AND checkin > #{l2}")
    end
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by{|x| x.res_to_listings }
  end

  def self.most_res
    City.all.max_by{|x| x.reservations.size }
  end


  def res_to_listings
    a = listings.size
    if a != 0
      reservations.size.to_f/a
    else
      0
    end
  end

end

