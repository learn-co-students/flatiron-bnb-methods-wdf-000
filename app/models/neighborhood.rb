class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(beginning, ending)
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
  	  reservations.count.fdiv(listings.count)
  	else
  	  0
  	end
  end
  
  def self.highest_ratio_res_to_listings
   	Neighborhood.all.max_by {|n| n.ratio_res_to_listings}
  end

  def self.most_res
  	Neighborhood.all.max_by {|x| x.reservations.size }
  end

end
