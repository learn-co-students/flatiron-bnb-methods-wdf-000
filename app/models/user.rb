class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  #as a host
  has_many :guests, through: :reservations, foreign_key: 'guest_id'
  has_many :host_reviews, through: :reservations, source: 'review'

  #as a guest
  #to find the hosts we need create a join table beteween listings and trips (reservation as a guest)
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, through: :trip_listings, foreign_key: 'host_id'

end
