class Review < ActiveRecord::Base
  belongs_to :reservation # fk reservation_id
  belongs_to :guest, :class_name => "User" # fk guest_id

  validates_presence_of :description, :rating, :reservation_id
  validate :checked_out?
  
  def checked_out?
    if !self.reservation.blank? && self.reservation.checkout > Date.today
        errors.add(:review, "error: reservation must be checked out")
    end
  end

end
