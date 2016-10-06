class User < ActiveRecord::Base

  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    ary = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        @user = User.find_by_id(reservation.guest_id)
        if !ary.include?@user
            ary << @user
        end
      end
    end
    ary
  end

  def hosts
    ary = []
    self.trips.each do |trip|
      the_listing = Listing.find_by_id(trip.listing_id)
      @host = User.find_by_id(the_listing.host_id)
      if !ary.include?@host
        ary << @host
      end
    end
    ary
  end

  def host_reviews
    ary = []
    self.listings.each do |listing|
      listing.reviews.each do |review|
        ary << review
      end
    end
    ary
  end


end
