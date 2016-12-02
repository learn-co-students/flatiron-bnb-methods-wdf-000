class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings







  def city_openings(date1, date2)
    self.listings.each do |listing|
      listing.reservations.find do |reservation|
        if reservation.checkin.to_s < date1 || reservation.checkout.to_s > date2
          reservation.listing
        end
      end
    end
  end



  def self.highest_ratio_res_to_listings
    num = 0
    city = nil
    City.all.each do |citi|
        if citi.reservations.count/citi.listings.count > num
          num = citi.reservations.count/citi.listings.count
          city = citi
        end
    end
    city
  end




  def self.most_res
    x = 0
    city = nil
    self.all.each do |citi|
      if citi.reservations.size > x
        x = citi.reservations.size
        city = citi
      end
    end

    city
  end











end
