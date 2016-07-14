class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id

   validate :accepted_past_reservation

  private

  def accepted_past_reservation
    errors.add(:reservation_id, "Reviews can only be made on past, accepted reservations.") unless reservation_id.nil? || Reservation.find(reservation_id).nil? || (Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Time.now)
  end
end
