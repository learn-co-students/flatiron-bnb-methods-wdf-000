class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def self.most_res
    reservations = Neighborhood.joins(:reservations).group(:neighborhood_id).count
    Neighborhood.find(reservations.key(reservations.values.max))
  end

  def neighborhood_openings(date1, date2)
      #first, parse dates into Date objects
      date1_parsed = Date.parse date1
      date2_parsed = Date.parse date2
      array_list = self.listings.collect do |listing|
        if listing.reservations.empty?
          listing
        else
          listing if listing.reservations.all? {|reservation| (date1_parsed < reservation.checkin ||  date1_parsed > reservation.checkout) && (date2_parsed > reservation.checkout || date2_parsed < reservation.checkin)}
        end
    end
  end

  def self.highest_ratio_res_to_listings
    booking_rates = Neighborhood.all.each_with_object(Hash.new(0)) do |nbh, booking_rates|
      booking_rates[nbh] = nbh.reservations_to_listings
    end
    booking_rates.key(booking_rates.values.max)
  end

  def reservations_to_listings
    number_of_listings = self.listings.size
    number_of_reservations = self.listings.collect {|listing| listing.reservations.size}.sum
    number_of_listings > 0 ? ration = number_of_reservations / number_of_listings : 0
  end


end
