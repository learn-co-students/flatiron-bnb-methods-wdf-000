class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :guest_is_not_host, :available?, :date_validity

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:id, "Cannot reserve your own listing!")
    end
  end

  def available?
    if checkin && checkout
      self.listing.reservations.each do |reservation|
        if (self.checkin.to_s..self.checkout.to_s).overlaps?(reservation.checkin.to_s..reservation.checkout.to_s)
          errors.add(:listing, 'listing is not available for reservation at this time')
        end
      end
    end
  end

  def date_validity
    if (checkin.to_s >= checkout.to_s)
      errors.add(:id, 'Please enter valid checkin and checkout dates')
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end


end
