class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, :through => :listing

  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host, :available?, :valid_dates?, :dates_not_the_same

  def guest_is_not_host
    errors.add(:guest, 'Cannot be both host and guest') if self.listing.host == self.guest
  end

  def available?
    if self.checkin && self.checkout
      errors.add(:listing, 'Cannot make a reservation at this time') if !self.listing.is_available?(self.checkin, self.checkout)
    end
  end

  def valid_dates?
    if self.checkin && self.checkout && self.checkout < self.checkin
      errors.add(:checkin, 'Cannot be after checkout')
    end
  end

  def dates_not_the_same
    if self.checkin && self.checkout && self.checkout == self.checkin
      errors.add(:checkout, 'Cannot be the same date as checkin')
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.listing.price * self.duration).to_f
  end
end
