class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true

  validates :reservation, presence: true

  before_validation :real_visit

  private
  def real_visit
    if !rating.nil? && !description.nil? && !self.reservation.nil?
      self.reservation.status == "accepted" && self.reservation.checkout < Date.today
    end
  end

end
