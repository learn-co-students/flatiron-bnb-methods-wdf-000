class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date0, date1)
    listings.select do |listing|
      if listing.reservations
        overlaps = listing.reservations.select do |res|
          !(res.checkout < Date.parse(date0) || res.checkin > Date.parse(date1))
        end
      end
      overlaps.empty?
    end
  end

  def self.highest_ratio_res_to_listings
    ratios = all.map do |neighborhood|
      if neighborhood.neighborhood_reservations.to_f != 0
        neighborhood.neighborhood_reservations.to_f / neighborhood.listings.count
      else
        0
      end
    end
    all[ratios.index(ratios.max)]
  end

  def self.most_res
    reservations = all.map{|neighborhood| neighborhood.neighborhood_reservations}
    all[reservations.index(reservations.max)]
  end

  def neighborhood_reservations
    self.listings.map{|listing| listing.reservations.count}.inject(0, :+)
  end


end
