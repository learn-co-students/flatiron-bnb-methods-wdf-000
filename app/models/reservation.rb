class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :host, through: :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :own_listing, :available, :checkin_before_checkout

  def own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, 'cannot make a reservation on your own listing')
    end
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |res|
      unavailable_dates = (res.checkin..res.checkout).to_a
      if unavailable_dates.include?( checkin ) || unavailable_dates.include?(checkout)
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, 'checkin date must be earlier than checkout date')
    end
  end

  # instance methods

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

end
