class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


  extend Ratio::ClassMetods

  def neighborhood_openings(start_date, end_date)
    self.listings.select{ |listing| listing.reservations.where("checkout < start_date OR checkin > end_date")}
  end

end
