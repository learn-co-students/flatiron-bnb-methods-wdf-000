class User < ActiveRecord::Base
  has_many :listings, foreign_key: :host_id
  has_many :reservations, through: :listings
  has_many :trips, foreign_key: :guest_id, :class_name => "Reservation"
  has_many :reviews, foreign_key: :guest_id
  
  # as host
  # knows about the guests its had
  has_many :guests, through: :reservations
  # knows about its reviews from guests
  has_many :host_reviews, through: :guests, source: :reviews

  # as guest
  # has rented a number of times
  has_many :rents, through: :trips, source: :listing
  # knows about the hosts its had
  has_many :hosts, through: :rents
end
