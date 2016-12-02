class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :can_not_make_reservation_on_your_own
  validate :available?

##custom_validations
  def can_not_make_reservation_on_your_own
    if self.listing.host_id == self.guest_id
      errors.add(:guest_id, "can not make reservation on your own")
    end
  end

  def available?
    if self.checkin == nil
      errors.add(:id, "needs both checkin date and checkout date.")
    elsif self.checkout == nil
      errors.add(:id, "needs both checkin date and checkout date.")
    elsif self.listing.reservations.any?{|reservation| (self.checkin <= reservation.checkout) && (self.checkout >= reservation.checkin)}
        errors.add(:id, "dates are not available.")
    elsif self.checkin > self.checkout
        errors.add(:id, "checkin date has to be before the checkout date.")
    elsif self.checkin == self.checkout
        errors.add(:id, "checkin and checkout dates can not be the same.")  
    end
  end

##instance_methods
  
  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end
  
end
