class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :presence => true
  validate :review_valid?

  def review_valid?
    if reservation_id.nil? || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation, "Reservation not found, not accepted or not checked out")
    end
  end
end
