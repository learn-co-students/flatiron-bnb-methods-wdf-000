class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date1, date2)
    opening = Array.new
    self.listings.each do |l|
      a = l.reservations.any?{|r| date1 <= r.checkout.to_s && date2 >= r.checkin.to_s} # overlap
      opening << l if a == false #only add if there is no overlap
    end
    opening
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|city| (city.reservations.size.to_f)/(city.listings.size.to_f)}
  end

  def self.most_res
    self.all.max_by{|city| city.reservations.size}
  end

end


