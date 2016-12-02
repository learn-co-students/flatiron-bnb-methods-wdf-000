class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    blo = lambda {|first, last| first.ratio <=> last.ratio}
    all.max(&blo)
  end
 
  def self.most_res
    blo = lambda {|first,last| first.num_of_reservations <=> last.num_of_reservations} 
    all.max(&blo) 
  end

  def neighborhood_openings(start_date, end_date) 
    reservations.select {|res| res.checkin <= Date.parse(start_date) && res.checkout <= Date.parse(end_date)}.map(&:listing)
  end

  def num_of_reservations
    listings.map(&:reservations).map(&:count).reduce(:+) || 0
  end

  def ratio
    num_of_reservations / listings.count rescue 0
  end

end
