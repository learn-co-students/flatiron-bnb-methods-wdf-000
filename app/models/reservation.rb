class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :host, through: :listing 
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :availability
  validate :date_validity
  validate :self_own

  def availability
    if self.listing.reservations && checkin && checkout
      co_conflict = listing.reservations.detect{|res| res.checkout > self.checkout && res.checkin < self.checkout}
      errors.add(:checkout, "checkout not available") if co_conflict
      ci_conflict = listing.reservations.detect{|res| res.checkin < self.checkin && res.checkout > self.checkin}
      errors.add(:checkin, "checkin not available") if ci_conflict
    end
  end

  def date_validity
    if checkin && checkout && (checkout == checkin || checkout < checkin)
      errors.add(:checkout, "invalid date order")
      errors.add(:checkin, "invalid date order")
    end
  end

  def self_own
    errors.add(:guest_id, "you can't rent your own place") if self.listing.host == self.guest
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

end
