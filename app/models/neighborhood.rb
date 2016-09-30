class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(one, two)
    # binding.pry
    self.listings.each do |list|
      list.reservations.select do |res|
        res.checkout.to_s <= one && res.checkin.to_s >= two && res == []
      end
    end
  end

  def self.highest_ratio_res_to_listings
    x = nil
    y = 0
    Neighborhood.all.each do |hood|
      hood.listings.each do |list|
        if list.reservations.count > y
          y = list.reservations.count
          x = hood
        end
      end
    end
    x
  end

  def self.most_res
    y = nil
    z = 0
    Neighborhood.all.each do |hood|
      x = 0
      hood.listings.each do |list|
        x = x + list.reservations.count
      end
      if x > z
        z = x
        y = hood
      end
    end
    y
  end

end
