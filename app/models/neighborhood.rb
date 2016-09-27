class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(startdate, enddate)
    answer = []
    self.listings.each do |listing|
      if !listing.reservations.any?{|reservation| (Date.parse(startdate) <= reservation.checkout) && (Date.parse(enddate) >= reservation.checkin)}
        answer << listing
      end
    end
    answer
  end

  def self.highest_ratio_res_to_listings
    max = 0
    answer = self.first
     self.all.each do |city|
       list_size = city.listings.size
       city.listings.each do |listing|
          if listing.reservations.size/list_size > max
            max = listing.reservations.size/list_size
            answer = city
          end
       end
     end
     answer
  end

  def self.most_res
    max = 0
    answer = self.first
    self.all.each do |city|
      city.listings.each do |listing|
        if listing.reservations.size > max
          max = listing.reservations.size
          answer = city
        end
      end
    end
    answer
  end



end
