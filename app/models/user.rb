class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations, :class_name => "User"

  has_many :trip_listings, through: :trips, :source => :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => 'host_id'
  has_many :host_reviews, through: :hosts, source: :review
  has_many :host_reviews, :through => :reservations, :source => :review
  # validate :host_reviews



  # def host_reviews
  #   # binding.pry
  #   self.listings.each do |listings|
  #     listings.reviews
  #   end
  # end


end
