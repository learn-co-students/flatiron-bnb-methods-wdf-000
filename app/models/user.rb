class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :hosts, :through => :trips, :source => :listing, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews


  # def guests
  #   guest_names = []
  #   reservations.each do |reservation|
  #     guest_names << reservation.guest
  #   end
  #   guest_names
  # end
end
