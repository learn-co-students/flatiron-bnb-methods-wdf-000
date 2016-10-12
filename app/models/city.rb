require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date1, date2)
  	listings.each do |listing|
  		listing.reservations.find do |reservation|
  			if reservation.checkin.to_s < date1 || reservation.checkout.to_s > date2
  				reservation.listing
  			end
  		end
  	end
  end

  def self.highest_ratio_res_to_listings
  	num = 0
  	city = nil
 	self.all.each do |city_var|
  		if city_var.reservations.count/city_var.listings.count > num
  			num = city_var.reservations.count/city_var.listings.count
  			city = city_var
  		end
  	end
  	city
  end

  def self.most_res
  	num = 0
  	city = nil
  	self.all.each do |city_var|
  		if city_var.reservations.size > num
  			num = city_var.reservations.size
  			city = city_var
  		end
  	end
  	city 
  end

end


