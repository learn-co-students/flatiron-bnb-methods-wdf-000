class Neighborhood < ActiveRecord::Base
  include Sharedmethod
  
  belongs_to :city
  has_many :listings

  def neighborhood_openings(startdate, enddate)
    open_listings = []
    
    self.listings.each do |listing|

      open_listings << listing unless listing.reservations.any?{|reservation| (Date.parse(startdate) <= reservation.checkout) && (Date.parse(enddate) >= reservation.checkin)}

    end
    
    open_listings
  end

end
