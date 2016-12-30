class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :valid_reservation?

  private

  def valid_reservation?
    if reservation && (reservation.status != "accepted" || reservation.checkout > Date.today)
      errors.add(:reservation, "Sorry, you cannot leave a review just yet.")
    end
  end
end
