class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :dates

  validate :owner_of_listing

  validate :checkin_date

  validate :available

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private

    def owner_of_listing
      if self.listing.host_id == self.guest_id
        errors.add(:listing, "owner cannot book own listing")
      end
    end

    def dates
      if self.checkin == self.checkout
        errors.add(:checkin, "checkin is the same as checkout")

      end

    end

    def checkin_date
      if self.checkin && self.checkout && self.checkin >= self.checkout
          errors.add(:guest_id, "checkin is after checkout")
      end
    end


#
#     def available
#       # result =  nil
#         self.listing.reservations.each do |r|
#         #  if !self.listing.reservations.empty? && ((self.checkin > r.checkin && self.checkout > r.checkin) || (self.checkin < r.checkin && self.checkout <= r.checkin))
#           #  result = true
#           # binding.pry

#           if !(r.checkin && self.checkin > r.checkin || r.checkout && self.checkout > r.checkin)
#             errors.add(:checkin, "checkin and checkout unavailable")
#           elsif !(r.checkin && self.checkin < r.checkin || r.checkout && self.checkout < r.checkin)
#              errors.add(:checkin, "checkin and checkout unavailable")
#          end
#         end
    # end

    def available
      self.listing.reservations.each do |r|
        if self.checkin.nil? || !(r.checkin && r.checkin < self.checkin)
          errors.add(:checkin, "checkin and checkout unavailable")
        # elsif (r.checkin && r.checkin < self.checkin) == false
        #   errors.add(:checkin, "checkin and checkout unavailable")
         end
       end
    end


end
