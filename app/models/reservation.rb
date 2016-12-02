class Reservation < ActiveRecord::Base
  validates :checkin, :checkout, presence: true
  validate :check_listing

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  def check_listing
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

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

end
