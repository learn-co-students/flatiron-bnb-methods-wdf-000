class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(beginning, ending)
  	listings.select do |list|
  		list.reservations.select do |reserv|
  			if Date.parse(beginning) == reserv.checkin && Date.parse(ending) == reserv.checkout
  				reserv.availability?
  			end
		end
  	end
  end

  def ratio_res_to_listings
  	if listings.count > 0
  		listings.map do |list|
  			list.reservations.count.fdiv(listings.count)
  		end
    else
      0
  	end
  end
  
  def self.highest_ratio_res_to_listings
   	City.all.max_by {|c| c.ratio_res_to_listings}
  end

  def self.most_res
  	City.all.max_by{|x| x.reservations.size }
  end
end

