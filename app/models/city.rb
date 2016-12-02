class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(one, two)
    #  binding.pry
     answer_array = []
     self.listings.each do |listing|
       answer_array << listing
       listing.reservations.each do |reservation|
         if reservation.checkin.to_s < one ||  reservation.checkin.to_s > two
           #we good
         else
            answer_array.delete(listing)
         end
       end
     end
     answer_array
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
