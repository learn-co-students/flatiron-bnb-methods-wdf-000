class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validate :reservation_is_valid_accepted_and_ended

  def reservation_is_valid_accepted_and_ended
    unless reservation && reservation.status == "accepted" && reservation.checkout < Time.now
      errors.add(:reservation, "Reservation is not valid, has not been accepted, or has not yet reached checkout")
    end
  end
end
