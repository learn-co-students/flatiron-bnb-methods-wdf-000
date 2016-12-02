class User < ActiveRecord::Base

  #As host
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings
  has_many :guests, through: :listings
  has_many :host_reviews, through: :reservations, :source => 'review'

  #As guest
  has_many :trips, :class_name => 'Reservation', :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :trip_listings, through: :trips, :source => 'listing'
  has_many :hosts, through: :trip_listings


  ##as guest
  # def hosts
  #   self.trips.collect do |trip|
  #     trip.listing.host
  #   end
  # end

  ##as host
  # def host_reviews
  #   self.reservations.collect do |reservation|
  #     reservation.review
  #   end
  # end

end



