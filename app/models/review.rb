class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: :true
  validates :reservation, presence: :true
  validate :trip_completed

  def trip_completed
  	if (reservation && reservation.status != 'accepted' ) || (reservation && Date.today < reservation.checkout) 
  		errors.add(:Review, "You are not authorized to leave a review!")
  	end
  end
end
