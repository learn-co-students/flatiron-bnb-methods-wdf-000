class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing

  validates_presence_of :checkin, :checkout
  validate :no_same_id, :availability, :checkout_before_checkin

  def duration
    checkout - checkin
  end

  def total_price
    self.listing.price * duration
  end


  def openings(start_date, end_date)
    self.listings.select {|l| l.reservations.where("checkout < start_date OR checkin > end_date")}
  end

  def no_same_id
    errors.add(:guest_id, "You can't make a reservation on your own listing") if self.listing.host == self.guest
  end

  def availability
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  # def availability
  #   if checkout != nil && checkin != nil 
  #     self.listing.reservations.find do |r| 
  #       booked = r.checkin..r.checkout 
  #       if booked == self.checkin || booked == self.checkout 
  #         errors.add(:guest_id, "This listing is not available for the dates you requested") 
  #       end
  #     end
  #   end
  # end

  def checkout_before_checkin
    errors.add(:guest_id, "Check out date must be before Check In date") if checkin != nil && checkout != nil && checkout < checkin || checkout == checkin
  end

end
