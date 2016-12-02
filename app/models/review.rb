class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true

  validate :reservation_exists

  def reservation_exists
    reserve = Reservation.find_by_id(self.reservation_id)
    if reserve != nil
      if reserve.status == "accepted" && reserve.checkout < Date.today
        return true
      else
        errors.add(:reservation_id, "You never reserved this!!")
      end
    end
  end

end
