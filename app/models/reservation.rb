class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :your_own_listing?, :listing_available?, :valid_date?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def your_own_listing?
    if guest_id == listing.host_id
      errors.add(:guest_id, "Sorry, you cannot make a reservation on your own listing.")
    end
  end

  def listing_available?
    listing.reservations.each do |reservation|
      if self.checkin != nil && self.checkout != nil
        if self.checkin <= reservation.checkout && reservation.checkin <= self.checkout || self.checkin >= self.checkout
          errors.add(:guest_id, "Please try again.")
        end
      end
    end
  end

  def valid_date?
    if (checkin.to_s >= checkout.to_s)
      errors.add(:guest_id, "Sorry, these check-in and check-out dates are invalid.")
    end
  end
end
