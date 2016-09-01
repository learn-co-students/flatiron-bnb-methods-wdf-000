class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  before_validation :irs_is_watching_u
  before_validation :check_availability
  before_validation :no_wormholes


  def duration
   (self.checkout - self.checkin).to_i  if !self.checkin.nil? && !self.checkout.nil?
  end


  def total_price
    self.listing.price * duration
  end

  private
  def irs_is_watching_u
      false if self.listing.host_id == self.guest_id
  end

  def check_availability
    if !self.checkin.nil? && !self.checkout.nil?
      self.listing.reservations.none?{|res| (self.checkin > res.checkin && self.checkout < res.checkout) || (res.checkin < self.checkout && res.checkin > self.checkin) || (res.checkout > self.checkin && res.checkout < self.checkout)}
    end
  end

  def no_wormholes
    if !self.checkin.nil? && !self.checkout.nil?
      self.checkin < self.checkout
    end
  end
end
