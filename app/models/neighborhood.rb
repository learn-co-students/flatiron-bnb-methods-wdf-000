class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations , through: :listings

  def neighborhood_openings(d1,d2)
    listings.select do |x|
      x.reservations.where("checkout < #{d1} AND checkin > #{d2}")
    end
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by{|x| x.res_to_listings }
  end

  def self.most_res
    Neighborhood.all.max_by{|x| x.reservations.size }
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
