class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :same_id, :dates_correct, :available

  def booked_dates
    @booked_dates = checkin..checkout
  end

  def duration
    (checkout-checkin).to_i
  end

  def total_price
    duration*listing.price
  end

  def available
      # binding.pry
      Reservation.where.not(id: id).each do |r|
        booked_dates = r.checkin..r.checkout
        if booked_dates === checkin || booked_dates === checkout
          errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
        end
    end
  end


  def same_id
    if listing.host_id == guest_id
      errors.add(:guest_id, "cannot be the same as host_id")
    end
  end

  def dates_correct
    # binding.pry
    if checkout && checkin && checkin >= checkout
      errors.add(:checkin, "cannot be after checkout date")
    end
  end
end
