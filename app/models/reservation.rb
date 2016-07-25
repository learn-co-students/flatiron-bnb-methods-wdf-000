class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :check_reservation_on_host, :available_listing, :checkout_after_checkin

  def duration
    self.checkout - self.checkin
  end

  def total_price
    Listing.find(self.listing_id).price * self.duration
  end

private
  def check_reservation_on_host
    if Listing.find(self.listing_id).host_id == self.guest_id
      errors.add(:guest_id, "cannot make a reservation on your own listing")
    end
  end

  def available_listing
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkout_after_checkin
    if checkin && checkout && (checkin >= checkout)
      errors.add(:checkin, "checkin date cannot be after checkout date")
    end
  end
end
