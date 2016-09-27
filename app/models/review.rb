class Review < ActiveRecord::Base
  validates :rating, :description, :reservation_id, presence: true
  validate :res_not_accepted_res_not_passed

 def res_not_accepted_res_not_passed
   if self.reservation_id == nil
     errors.add(:id, "can't be reviewed without a reservation")
   elsif self.reservation.status != "accepted"
     errors.add(:id, "can't be reviewed while reservation has not been accepted.")
   elsif self.reservation.checkout > Date.today
     errors.add(:id, "can't be reviewed before checkout.")
   end
 end

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

end
