class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description
  validate :check_res

  def check_res
    if self.reservation == nil || (self.reservation.checkout > Time.now) || self.reservation.status == "pending" 
      errors.add(:guest_id, "Reservation invalid for the review")
    end
  end

end
