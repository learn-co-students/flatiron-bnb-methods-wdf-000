class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  #!!! Should have a checkin and a checkout method.

  #Make sure the guest and host aren't the same user.
  validate :can_not_make_reservation_on_your_own, :listing_is_available?, :checkin_before_checkout
  validates :checkin, presence: true
  validates :checkout, presence: true

  # custom methods:
  def can_not_make_reservation_on_your_own
    if self.listing.host_id == self.guest_id
      errors.add(:id, "can not make reservation")
    end
  end


  def listing_is_available?
    if checkin && checkout
      (self.checkin..self.checkout).each do |day|
        # does this reservations listing have any
        # other reservations on this day?
        if self.listing.is_reserved?(day)
          errors.add(:checkin, "dates are not available")
          break;
        # elsif self.checkin > self.checkout
        #   errors.add(:id, "checkin must be before checkout")
        elsif self.checkin == self.checkout
          errors.add(:id, "checkin and checkout can't be the same")
        end
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if self.checkin > self.checkout
        errors.add(:id, "checkin must be before checkout")
      end
    end
  end

  # instance methods:
  def duration
      # duration based on checkin and checkout dates
  		(self.checkout - self.checkin).to_i
  end

  def total_price
      # knows about its total price
      # returns the price using the duration and the price per day
  		self.listing.price * self.duration
  end

end
