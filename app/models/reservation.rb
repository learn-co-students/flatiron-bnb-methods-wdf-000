class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_cannot_be_host
  validate :checkin_before_checkout
  validate :available

  def duration
    (checkout - checkin).to_i  
  end

  def total_price
    Listing.find(listing_id).price * duration
  end

  private

  def guest_cannot_be_host
    errors.add(:guest_id, "A guest cannot also be the host.") unless guest_id != Listing.find(listing_id).host_id
  end

  def available
    errors.add(:checkin, "Sorry, there seems to be an existing reservation at that time.") unless !checkin.nil? && !checkout.nil? && self.listing.reservations.map{|reservation| checkin < reservation.checkout && checkout > reservation.checkin }.none?
  end

  def checkin_before_checkout
    errors.add(:checkin, "Checkin time must be before checkout.") unless !checkin.nil? && !checkout.nil? && checkin < checkout
  end
end
