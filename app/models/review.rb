class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :reservation_status

  def reservation_status
    if reservation && (reservation.status != 'accepted' || reservation.checkout > Date.today)
      errors.add(:reservation_id, "invalid reservation")
    end
  end
end
