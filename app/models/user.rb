class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations
  has_many :hosts, through: :trips, source: :guests

  def hosts
    self.trips.collect do |trip|
      trip.listing.host
    end
  end

  def host_reviews
    self.reservations.collect do |reservation|
      reservation.review
    end
  end

end
