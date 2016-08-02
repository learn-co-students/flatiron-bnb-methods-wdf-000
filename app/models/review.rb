class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :associations

  def associations
    if !reservation || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation_id, "you haven't completed a stay here!")
    end
  end


end
