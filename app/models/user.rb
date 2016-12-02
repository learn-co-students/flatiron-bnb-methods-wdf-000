class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    # binding.pry
    listings.map do |list|
      list.guests
    end[0]
  end

  def hosts
    # binding.pry
    trips.map do |trip|
      trip.listing.host
    end
  end

  def host_reviews
    # binding.pry
    reservations.map do |res|
      res.review
    end
  end


end
