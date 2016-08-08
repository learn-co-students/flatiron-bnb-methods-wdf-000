class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :cheater, :time_traveler, :availability

  def cheater
    if listing.host == guest
      errors.add(:Reservation,"You cannot do that")
    end
  end

  def time_traveler
    if checkin && checkout && checkin >= checkout 
      errors.add(:Reservation,"You cannot do that")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * 50.to_f
  end

  def availability
    if checkin && checkout  
      Reservation.all.each do |x|
          if x.id != id && ( x.checkin <= checkin && checkin <= x.checkout || x.checkin <= checkout && checkout <= x.checkout )
            errors.add(:Reservation, "Try again")
          end
      end 
    end
  end

end
