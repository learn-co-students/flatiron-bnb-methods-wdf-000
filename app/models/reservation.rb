class Reservation < ActiveRecord::Base
  include Checkable::InstanceMethods
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :date_inputs, :cannot_reserve_personal_listing
  validate :date_availability, on: :create

  # Custom validation methods

  def date_inputs
    # check both date inputs
    if !self.checkin && !self.checkout
      errors.add(:date, "input problem")
    # check each date input
    elsif !self.checkin || !self.checkout
      errors.add(:date, "input problem")
    elsif self.checkin > self.checkout
      errors.add(:date, "error: checkin must be before checkout")
    elsif self.checkin == self.checkout
      errors.add(:date, "error: checkin and checkout can not be same")
    end
  end

  def cannot_reserve_personal_listing
    user = User.find_by(id: self.guest_id)
    listing = Listing.find_by(id: self.listing_id)
    if !!user && user.listings.include?(listing)
      errors.add(:reservation, "error: cannot reserve personal listing")
    end
  end

  def date_availability
    # execute the code below only when no errors exist
    if self.errors.empty?
      listing = Listing.find_by(id: self.listing_id)
      # reservation_check checks for matches, returns array of matches or nils
      # if listing has no reservations returns an empty array
      reservations = reservation_check(listing, self.checkin.strftime, self.checkout.strftime)
      if !reservations.all? {|reservation| reservation == nil }
        errors.add(:reservation, "error: dates conflict with existing reservation")
      end
    end
  end

  # Instance methods

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    listing_price = Listing.find_by(id: self.listing_id).price.to_i
    listing_price * duration
  end

end
