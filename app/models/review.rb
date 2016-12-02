class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation

  validate :has_been_accepted, :checkout_has_happened

  def has_been_accepted
    errors.add(:reservation_id, "Your reservation has not been accepted") if reservation && reservation.status != "accepted"
  end

  def checkout_has_happened
    errors.add(:reservation_id, "Checkout has not happened yet") if reservation && reservation.checkout > Date.today
  end
end
