class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :self_listing
  validate :listing_available
  validate :checkin_before_checkout

  def duration
    (checkout-checkin).to_i
  end

  def total_price
    self.listing.price.to_f * duration
  end

  private

  def self_listing
    if self.guest_id == self.listing.host_id
      errors.add(:id, "You cant do that bro!!!!!")
    end
  end

  def listing_available
    if checkin && checkout
      self.listing.reservations.each do |reservation|
        if (self.checkin.to_s..self.checkout.to_s).overlaps?(reservation.checkin.to_s..reservation.checkout.to_s)
          errors.add(:id, "You cant do that bro!!!!!")
        end
      end
    end
  end

  def checkin_before_checkout
    if (checkin && checkout) && (checkin.to_s >= checkout.to_s)
      errors.add(:id, "You cant do that bro!!!!!")
    end
  end



end
