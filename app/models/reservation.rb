class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :cannot_reserve_your_listing, :listing_available, :logic


  def cannot_reserve_your_listing
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own listing!")
    end
  end

  def listing_available
    if checkin != nil  && checkout != nil
      available = true
      listing.reservations.each do |reservation|
        if reservation.checkout > checkin && reservation.checkin < checkin || reservation.checkout > checkout && reservation.checkin < checkout
            available = false
        end
      end
    end
    if !available
      errors.add(:guest_id, "Sorry place is booked on requested dates")
    else
      return true
    end
  end

  def logic
    if checkin != nil  && checkout != nil
      if checkin > checkout || checkin == checkout
        errors.add(:guest_id, "How can you checkout if you did not checkin?")
      else
        return true
      end
    end
  end

  def duration
    checkout.day - checkin.day
  end

  def total_price
    listing.price * duration
  end

end
