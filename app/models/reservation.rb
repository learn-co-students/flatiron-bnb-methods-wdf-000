class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :cannot_reserve_own_listing
  validate :checkin_before_checkout
  validate :listing_avail_checkin

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.listing.price)*duration
  end

  def cannot_reserve_own_listing
    curr_listing = Listing.find(listing_id)
    if curr_listing.host_id == self.guest_id
      errors.add(:id, "cannot reserve your own listing")
    end
  end

  def checkin_before_checkout
      if (self.checkin && self.checkout) && (self.checkin >= self.checkout)
        errors.add(:id, " invalid checkin and checkout times")
     end
  end

  def listing_avail_checkin
      if checkin && checkout
        self.listing.reservations.each do |res|
          if (self.checkin <= res.checkout && self.checkout >= res.checkin)
            errors.add(:id, "cannot reserve listing due to checkin time")
          end
        end
      end
  end

end




