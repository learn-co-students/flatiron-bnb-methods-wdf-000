class City < ActiveRecord::Base
  extend Stats

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings from,to
    self.listings.select{|l| l.reservations.where("checkout < ? OR checkin > ?", from, to)}
  end
end

