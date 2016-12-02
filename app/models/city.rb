class City < ActiveRecord::Base

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
 
  def city_openings(start_date, end_date)
    listings.select do |listing|
      listing.reservations.where("checkin < ? AND checkout > ?",start_date, end_date)
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|city| city.res_to_list_ratio}
  end
  
  def self.most_res
    self.all.max_by{|city| city.reservations.size}
  end


  def res_to_list_ratio
    listings.size > 0 ? reservations.size.to_f / listings.size.to_f : 0
  end

end

