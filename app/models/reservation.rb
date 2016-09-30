class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :conflict
  validate :time

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

  private

  def conflict
    # binding.pry
    if self.guest == self.listing.host
      errors.add(:listing_id, "Cannot book your own listing.")
    end
  end

  def time
    listing.reservations.each do |res|
      if self.checkin != nil && self.checkout != nil
      if self.checkin <= res.checkout && res.checkin <= self.checkout || self.checkin >= self.checkout
        errors.add(:checkin, "A.")
      end
    end
    end
  end

end
