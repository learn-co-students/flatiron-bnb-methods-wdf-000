class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :reservation_accepted_and_passed?

  def reservation_accepted_and_passed?
    if reservation.nil?
      # binding.pry
      errors.add(:guest, "cannot leave a review on a nonexistent reservation")
    elsif reservation.status == "pending" || reservation.checkout > Date.today
      errors.add(:rating, "can only be left on an accepted reservation, after the checkout date")
    end
  end

end
