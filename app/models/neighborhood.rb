class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(time1, time2)
    ary = []
    booked = false
    Listing.all.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.checkin.to_s <= time1 && reservation.checkout.to_s >= time2 && !ary.include?(listing)
          booked = true
        end
      end
      if !booked
        ary << listing
      end
    end
    ary
  end

  def self.highest_ratio_res_to_listings
    ary = []
    max = 0
    counter = 0
    Neighborhood.all.each do |a_neighborhood|
      a_neighborhood.listings.each do |listing|
        counter += listing.reservations.count
      end
      if counter != 0
        counter = counter/a_neighborhood.listings.count
        if counter > max
           max = counter
           ary[0] = a_neighborhood
        end
        counter = 0
      end
    end
    ary[0]
  end

  def self.most_res
    ary = []
    max = 0
    counter = 0
    Neighborhood.all.each do |a_neighborhood|
      a_neighborhood.listings.each do |listing|
        counter += listing.reservations.count
      end
      if counter > max
         max = counter
         ary[0] = a_neighborhood
      end
      counter = 0
    end
    ary[0]
  end

end
