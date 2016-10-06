class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(time1, time2)
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
    City.all.each do |a_city|
      a_city.listings.each do |listing|
        counter += listing.reservations.count
      end
      counter = counter/a_city.listings.count
      if counter > max
         max = counter
         ary[0] = a_city
      end
      counter = 0
    end
    ary[0]
  end

  def self.most_res
    ary = []
    max = 0
    counter = 0
    City.all.each do |a_city|
      a_city.listings.each do |listing|
        counter += listing.reservations.count
      end
      if counter > max
         max = counter
         ary[0] = a_city
      end
      counter = 0
    end
    ary[0]
  end

end
