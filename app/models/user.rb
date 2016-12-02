class User < ActiveRecord::Base
  # as a host
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, through: :listings, :foreign_key => 'guest_id'

  # as a guest
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  # has_many :hosts, through: :trips, source: :listings, :foreign_key => 'host_id'
 
  # As a guest has many hosts
  # Collect the host from each trip's listing
  def hosts
    trips.collect do |trip|
      trip.listing.host
    end
  end

  # As a host, has many reviews
  # Collect the review from each reservation
  def host_reviews
    reservations.collect do |reservation|
      reservation.review
    end
  end
end
