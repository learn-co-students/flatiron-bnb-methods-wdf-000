require 'pry'

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  belongs_to :host, :class_name => "User", :foreign_key => 'host_id'
  has_one :review
  validates_presence_of :checkin, :checkout

  validate :invalid_same_ids
  validate :invalid_checkin_check

 def invalid_same_ids
   if self.guest_id == self.listing.host_id
     errors.add(:guest_id, "can't be the same")
   end
 end

 def invalid_checkin_check
   self.listing.reservations.each do |reservation|
    if checkin
      if reservation.checkout > self.checkin || self.checkin > self.checkout || self.checkin == self.checkout
         errors.add(:checkin, "invalid checkin date")
     end
   end
   end
 end

 def duration
  (self.checkout - self.checkin).to_i
 end

 def total_price
  (self.listing.price.to_i * duration)
 end

 


end
