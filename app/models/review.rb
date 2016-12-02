class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  
  validate :review_condition

  def review_condition
    if self.reservation_id.nil?
      errors.add(:guest_id, "You can not give a review withoiut a reservation")
    elsif self.reservation.status != "accepted"
      errors.add(:reservation, "Reservation status should be accepted first")
    elsif self.reservation.checkout > Date.today
      errors.add(:reservation, "Reservation has to be ended first to give a review")
    end
  end

end
