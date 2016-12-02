class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # def city_openings(date_1, date_2)
  #   array = []
  #   Listing.all.each do |list|
  #     if list.reservations == []
  #       array << list
  #     end
  #     list.reservations.select do |res|
  #       # binding.pry
  #       if res.checkout.to_s <= date_1 && res.checkin.to_s >= date_2
  #         array << list
  #       end
  #     end
  #   end
  #   binding.pry
  #   array = array.uniq
  #   array
  # end

  def city_openings(one, two)
    Listing.all.each do |list|
      list.reservations.select do |res|
        res.checkout.to_s <= one && res.checkin.to_s >= two && res == []
      end
    end
  end

  def self.highest_ratio_res_to_listings
    x = nil
    y = 0
    City.all.each do |city|
      city.listings.each do |list|
        if list.reservations.count > y
          y = list.reservations.count
          x = city
        end
      end
    end
    x
  end

  def self.most_res
    y = nil
    z = 0
    City.all.each do |city|
      x = 0
      city.listings.each do |list|
        x = x + list.reservations.count
      end
      if x > z
        z = x
        y = city
      end
    end
    y
  end



end
