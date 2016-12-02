class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_cannot_be_guest
  validate :checkin_and_checkout_cannot_be_same_date
  validate :checkin_is_before_checkout
  validate :place_is_unavailable

  def host_cannot_be_guest
    if guest == host
      errors.add(:host, "host cannot be guest")
    end
  end

  def checkin_and_checkout_cannot_be_same_date
    if checkin == checkout
      errors.add(:checkin, "checkin and checkout cannot be same date")
    end
  end

  def duration
    (checkout - checkin).to_i rescue -1
  end
  
  def total_price
    duration * listing.price.to_f
  end

  def checkin_is_before_checkout
    if duration < 0
      errors.add(:checkout, "checkout cannot be before checkin")
    end
  end

  def place_is_unavailable
    self.class.all.each do |res|
      unavailable = (res.checkin..res.checkout).to_a
      if res.id != id && (unavailable.include?(checkin) || unavailable.include?(checkout))
	errors.add(:guest, "place is unavailable in the selected time range")
      end
    end 
  end

end
