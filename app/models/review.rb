class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :review_check

  def review_check
    if reservation && (reservation.status != 'accepted' || reservation.checkout > Date.today)
      errors.add(:reservation, "Unable to leave a review yet.")
    end
  end
end
