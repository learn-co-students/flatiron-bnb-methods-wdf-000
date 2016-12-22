class Neighborhood < ActiveRecord::Base
  	belongs_to :city
  	has_many :listings
    # passing highest ratio with reservation assoc.
    has_many :reservations, through: :listings

  	def neighborhood_openings(arrival, leave) 
  		available_listings = []
  		self.listings.each do |listing|
  			available_listings << listing unless listing.reservations.any?{|reservation| (Date.parse(arrival) <= reservation.checkout) && (Date.parse(leave) >= reservation.checkin)}
  		# date ranges, date ranges overlap
      end
  		  available_listings
  	end

    def self.highest_ratio_res_to_listings
      # the highest amount of reservations per listing
      Neighborhood.all.max_by do |neighborhood|
        res = neighborhood.reservations.count
        neighborhood_listings = neighborhood.listings.count
        
        if neighborhood_listings != 0
          res/neighborhood_listings
        else
          0
        end
      end

    end

    # neighborhood with the most reservations
    def self.most_res
      Neighborhood.all.max_by do |neighborhood| 
        neighborhood.reservations.count
      end
    end

end
