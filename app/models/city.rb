class City < ActiveRecord::Base
  include Sharedmethod

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  def city_openings(startdate, enddate)
    open_listings = []

    self.listings.each do |listing|

      open_listings << listing unless listing.reservations.any?{|reservation| (Date.parse(startdate) <= reservation.checkout) && (Date.parse(enddate) >= reservation.checkin)}

    end
    
    open_listings
  end



end

