class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(date1, date2)
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
    hood = nil
    self.all.each do |neighborhood|
      neighborhood.listings.collect do |listing|
        if listing.reservations.count/neighborhood.listings.count > num
          num = listing.reservations.count/neighborhood.listings.count
          hood = neighborhood
        end
      end
    end
    hood
  end


  def self.most_res
    num = 0
    hood = nil
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > num
        num = neighborhood.reservations.count
        hood = neighborhood
      end
    end
    hood
  end

end
