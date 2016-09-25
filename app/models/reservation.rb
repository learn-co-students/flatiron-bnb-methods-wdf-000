class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate  :available, :check_out_after_check_in, :guest_and_host_not_the_same

  def duration
    (checkout - checkin).to_i
  end
  
  def total_price
    listing.price * duration
  end

  private

  def available
     if checkin && checkout
       # Reservation.all or self.class.all works as well
      listing.reservations.each do |res|
        if res.id != id && (checkin >= res.checkin &&  checkin <= res.checkout || checkout >= res.checkin && checkout <= res.checkout)
          errors.add(:guest_id, "The place is not vailable")
         end
      end
     end
   end


 def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can not be a guest for your own apartment")
    end
  end

  def check_out_after_check_in
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id,"Your check-out date needs to be after your checkin")
    end
  end
end
