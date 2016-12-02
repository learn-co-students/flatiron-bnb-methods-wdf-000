class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(min_date, max_date)
    listings.select do |lis|
      lis.reservations.where("checkin < ? and checkout > ?", min_date, max_date)
    end
  end

  def self.highest_ratio_res_to_listings
    all.max {|a, b| a.res_lis_ratio <=> b.res_lis_ratio }
  end

  def self.most_res
    all.max {|a, b| a.reservations.count <=> b.reservations.count }
  end

  def res_lis_ratio
    listings.count > 0 ? reservations.count / listings.count : 0
  end
end
