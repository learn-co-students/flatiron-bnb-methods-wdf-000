class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :accepted_and_checked_out

  def accepted_and_checked_out
    if self.reservation
      if self.reservation.status != "accepted" || Date.today < self.reservation.checkout
        errors.add(:reservation, 'Status must be accepted and you must be checked out')
      end
    end
  end
end
