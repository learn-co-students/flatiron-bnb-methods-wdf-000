class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings
  
  def neighborhood_openings(start_date, end_date)
    self.listings.select{|listing| listing.reservations.where("checkin < ? AND checkout > ?", start_date, end_date)}
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|a| a.res_list_ratio}
  end

  def self.most_res
    self.all.max_by{|a| a.reservations.count}
  end

  def res_list_ratio
    listings.count > 0 ? reservations.count.to_f / listings.count.to_f : 0
  end

end
