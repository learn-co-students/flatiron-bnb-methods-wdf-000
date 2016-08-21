class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :accepted, :after_checkout

  def after_checkout
    if reservation  && reservation.checkout > Date.today
      errors.add(:review, 'invalid before checkout')
    end
  end

  def accepted
    if reservation && reservation.status != 'accepted'
      errors.add(:review, 'invalid without accepted reservation')
    end
  end
end
