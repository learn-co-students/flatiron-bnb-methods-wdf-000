class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  #
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :associated_res

  # validate :after_checkout

  private
    def associated_res
      if self.reservation && (self.reservation.status != "accepted" ||  self.reservation.checkout > Date.today)
        errors.add(:reservation, "reservation hasnt been acceed")
      end
    end

    # def after_checkout
    #   if self.reservation && self.reservation.checkout > Date.today
    #     errors.add(:reservation, "date invalid")
    #   end
    #
    # end

end
