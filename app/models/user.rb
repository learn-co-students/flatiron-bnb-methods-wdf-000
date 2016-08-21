class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  # host
  has_many :guests, through: :reservations
  has_many :host_reviews, through: :guests, source: :reviews
  # guest
  has_many :hosts, through: :trips
end
