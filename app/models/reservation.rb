class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, :presence => true
  validate :guest_is_host?, :available?, :valid_date?



  def guest_is_host?
    if guest_id == listing.host_id
      errors.add(:host, "you already live there")
    end
  end

  def available?
    Reservation.all.each do |reservation|
      bookings = (reservation.checkin..reservation.checkout).to_a
      if reservation.id != id && (bookings.include?(checkin) || bookings.include?(checkout))
        errors.add(:guest, "unavailable for those dates")
      end
    end
  end

  def valid_date?
    if checkin.to_s >= checkout.to_s
      errors.add(:checkin, "Checkin and Checkout times not valid")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

end
