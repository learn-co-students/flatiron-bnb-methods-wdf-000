class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def host_reviews
    reservations.map{|reservation| reservation.guest.reviews}.flatten
  end

  def hosts
    trips.map{|trip| trip.listing.host}
  end

  def guests
    reservations.map{|reservation| reservation.guest}
  end
end
