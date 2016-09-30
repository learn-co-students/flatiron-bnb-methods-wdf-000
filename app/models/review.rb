class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :rezzy

  private

  def rezzy

    if reservation == nil || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation, "s")
    end
  end


end
