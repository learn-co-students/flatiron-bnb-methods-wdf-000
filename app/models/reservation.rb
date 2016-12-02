class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  before_validation :checkin_before_checkout
  before_validation :existing_listing?
  before_validation :checkin_and_checkout
  before_validation :not_same_date


   def checkin_before_checkout
    if checkin && checkout
      if self.checkin > self.checkout
        errors.add(:checkin, "The checkin time is before the checkout")
      end
    end
   end

	def existing_listing?
		if self.guest_id == self.listing.host_id
			errors.add(:listing_id, "You can't be both the host and the guest")
		end
	end 

  def checkin_and_checkout
	 if checkin && checkout
       	self.listing.reservations.each do |reservation|
         	if self.checkin <= reservation.checkin && self.checkout <= reservation.checkout || self.checkin >= reservation.checkin && self.checkout <= reservation.checkout || self.checkin <= reservation.checkin && self.checkout >= reservation.checkin
           		errors.add(:checkin, "This checkin time is taken")
         	end
       	end
     end
  end

  def not_same_date
   if checkin && checkout
   	if self.checkin == self.checkout
   		errors.add(:checkin, "No bueno checkin and checkout dates are the same")
   	end	
   end
  end

  def duration
    self.checkout.to_s.split("-").last.to_i - self.checkin.to_s.split("-").last.to_i
  end

  def total_price
    self.listing.price.to_i.to_f * duration
  end

end
