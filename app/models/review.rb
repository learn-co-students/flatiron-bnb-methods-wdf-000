class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  before_validation :no_res
  validates :rating, :description, :reservation_id, presence: true




  def no_res
    if self && self.reservation
      if self.reservation.checkout > Date.today || self.reservation.status != "accepted"
        errors.add(:reservation, "Your reservation is not over and therefor you cannot leave a review")
      end
    end
  end












end
