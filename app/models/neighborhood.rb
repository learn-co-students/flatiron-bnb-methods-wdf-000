class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.select do |reservation|
        reservation.checkout.to_s < start_date && reservation.checkin.to_s > end_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by{|neighborhood| neighborhood.listings.count > 0 ? (neighborhood.reservations.count)/(neighborhood.listings.count) : 0}
  end

  def self.most_res
    Neighborhood.all.max_by{|neighborhood| neighborhood.reservations.size}
  end
end
