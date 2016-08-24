class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_the_same, :checkout_after_checkin, :listing_available?

  def duration
    checkout-checkin
  end

  def total_price
    duration*listing.price
  end

  private

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def checkout_after_checkin 
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end

  def listing_available?
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      # binding.pry
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end
end
