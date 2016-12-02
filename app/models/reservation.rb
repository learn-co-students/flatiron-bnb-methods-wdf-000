class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :host_check, :availability_check, :checkin_check

  def host_check
    if listing.host_id == guest_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def availability_check
    return unless checkin && checkout
    Reservation.all.each do |reservation|
      if id != reservation.id && (
        reservation.booked_date === checkin ||
        reservation.booked_date === checkout
      )
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_check
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end

  def booked_date
    checkin..checkout
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

end
