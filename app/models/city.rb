class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods 

  def city_openings(start_date, end_date)
    listings.select {|listing| listing }
  end

  def self.highest_ratio_res_to_listings 
    blo = lambda {|first,last| first.ratio <=> last.ratio}
    all.max(&blo)
  end

  def self.most_res
    blo = lambda {|first,last| first.num_of_reservations <=> last.num_of_reservations}
    self.all.max(&blo)
  end

  def num_of_reservations
    listings.map(&:reservations).map(&:count).reduce(:+) rescue 0
  end

  def ratio
    num_of_reservations / listings.count
  end

end

