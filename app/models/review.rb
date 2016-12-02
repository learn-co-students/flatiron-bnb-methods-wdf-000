class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :review

  def review
    if !(self.reservation && self.reservation.status == "accepted" && self.reservation.checkout.to_s <= Time.new.strftime("%Y-%m-%d"))
      errors.add(:rating, "Cannot leave a valid review")
    end
  end

end
