class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings




  def neighborhood_openings(date1, date2)
    self.listings.each do |listing|
      if listing.reservations
        listing.reservations.find do |reserve|
          if reserve.checkin.to_s < date1 || reserve.checkout.to_s > date2
            reserve.listing
          end
        end
      end
    end
  end



   def self.highest_ratio_res_to_listings
    x = 0
    place = nil
    self.all.each do |neighborhood|
      neighborhood.listings.collect do |listing|

        if listing.reservations.count/neighborhood.listings.count > x
          x = listing.reservations.count/neighborhood.listings.count
          place = neighborhood
        end
      end
    end
    place
  end


  def self.most_res
    #must return the neighborhood with the most reservations
    x = 0
    place = nil
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > x
        x = neighborhood.reservations.count
        place = neighborhood
      end
    end
    place
  end












end
