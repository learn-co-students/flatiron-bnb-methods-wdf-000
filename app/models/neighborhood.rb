class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start_date, end_date)
    available = []
    listings.each do |listing|
      available << listing unless
      listing.reservations.find do |reservation|
        (start_date <= reservation.checkout.to_s) && (end_date >= reservation.checkin.to_s)
      end
    end
    available
  end

  def res_list_ratio
    listings.count > 0 ? reservations.count/listings.count : 0
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|neighborhood| neighborhood.res_list_ratio}
  end

  def self.most_res
    self.all.max_by{|neighborhood| neighborhood.reservations.size}
  end

end
