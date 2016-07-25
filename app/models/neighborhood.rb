class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start_date, end_date)
    self.listings.joins(:reservations).where("reservations.checkin <= :start_date AND reservations.checkout <= :end_date", {start_date: start_date, end_date: end_date})
  end

  def ratio_res_to_listings
    if self.listings.count > 0
      return self.reservations_count / self.listings.count
    end

    return 0
  end

  def reservations_count
    self.listings.inject(0) { |sum, listing| sum += listing.reservations.count } || 0
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max { |a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings }
  end

  def self.most_res
    Neighborhood.all.max { |a, b| a.reservations_count <=> b.reservations_count }
  end
end
