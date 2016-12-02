class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :check_rez
  validate :accepted

    def accepted
      if self.reservation
        if self.reservation.status != 'accepted'
          errors.add(:reservation, "accept reservation first")
        end
      else
        errors.add(:reservation, "does not exist")
      end
    end

    def check_rez
      if self.reservation
        if self.reservation.checkout > Date.today
          errors.add(:reservation, "Cannot enter review")
        end
      else
        errors.add(:reservation, "Cannot enter review")
      end
    end

end



# Review review validations is invalid without an associated reservation,
# has been accepted, and checkout has happened
