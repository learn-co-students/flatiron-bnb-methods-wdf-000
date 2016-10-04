class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  validates :checkin, :checkout, presence: true
  has_one :review
  before_validation :checkin_before_checkout
  before_validation :not_same_date
  before_validation :checkin_and_out?
  before_validation :existing_listing?
  has_one :host, through: :listing
  # has_one :host, through: :listing, :foreign_key => 'host_id'




  def existing_listing?
    if self.guest_id == self.listing.host_id
      errors.add(:listing_id, "You cannot be both host and guest")
    end
  end

  def checkin_and_out?
    if checkin && checkout
      self.listing.reservations.each do |res|
        if self.checkin <= res.checkin && self.checkout <= res.checkout || self.checkin >= res.checkin && self.checkout <= res.checkout || self.checkin <= res.checkin && self.checkout >= res.checkin
          errors.add(:checkin, "This checkin time is taken")
        end
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if self.checkin > self.checkout
        errors.add(:checkin, "The checkin time is before the checkout")
      end
    end
  end


  def not_same_date
    if checkin && checkout
      if self.checkin == self.checkout
        errors.add(:checkin, "checkin and checkout dates are the same")
      end
    end
  end



  def duration
     self.checkout.to_s.split("-").last.to_i - self.checkin.to_s.split("-").last.to_i
  end

  def total_price
    self.listing.price.to_s.to_f * duration
  end


















end
