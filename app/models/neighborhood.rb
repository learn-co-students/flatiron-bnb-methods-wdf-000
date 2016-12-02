class Neighborhood < ActiveRecord::Base
  extend Stats

  belongs_to :city
  has_many :listings

  def neighborhood_openings from,to
    self.listings.select{|l| l.reservations.where("checkout < ? OR checkin > ?", from, to)}
  end
end
