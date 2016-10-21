class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation

  # validates numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, only_integer: true }
  # validates :reservation, presence: true
  validate :accepted_and_checked_out


  private

  def accepted_and_checked_out
    if self.reservation
      if self.reservation.status != "accepted" || Date.today < self.reservation.checkout
        errors.add(:reservation, "invalid")
      end
    end
  end

end
