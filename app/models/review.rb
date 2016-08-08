class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating , presence: true

  validates :description , :reservation ,  presence: true
  validate :no_lying 


  def no_lying
    if ( reservation && reservation.status != 'accepted' ) || reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Try again")
    end
  end

end
