class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_only, :not_the_same, :checkin_before_checkout, :availability

  def guest_only
  	if listing.host == guest
  		errors.add(:Reservation, "You cannot make a reservation on your own listing!")
  	end
  end

  def duration
  	checkout - checkin
  end

  def total_price
  	duration * listing.price
  end

  def availability
  	if checkin && checkout
  		Reservation.all.each do |reserv|
  			if reserv.id != self.id && ( (reserv.checkin <= checkin && checkin <= reserv.checkout) || (reserv.checkin <= checkout && checkout <= reserv.checkout) )
  				errors.add(:Reservation, "Time Unavailable")
  			end 
  		end
  	end
  end

  def not_the_same
  	if checkin == checkout
  		errors.add(:Reservation, "Check-in and check-out dates cannot be the same!")
  	end
  end

  def checkin_before_checkout
  	if checkin && checkout && checkin >= checkout 
  		errors.add(:Reservation, "Check-in date cannot be after check-out date")
  	end
  end
end
