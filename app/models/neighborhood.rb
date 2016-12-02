class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


    def neighborhood_openings(checkin, checkout)
      self.listings.each do |listing|
        listing.reservations.find do |reservation|
          if reservation.checkin.to_s > checkin || reservation.checkout.to_s < checkout
            reservation.listing
          end
        end
      end
    end

    def self.highest_ratio_res_to_listings
      self.all.max_by do |neighborhood|
        if neighborhood.reservations.size > 0 && neighborhood.listings.size > 0
          (neighborhood.reservations.size)/(neighborhood.listings.size)
        else
          0
        end
      end
    end

    def self.most_res
      self.all.max_by{|neighborhood| neighborhood.reservations.size}
    end


end
