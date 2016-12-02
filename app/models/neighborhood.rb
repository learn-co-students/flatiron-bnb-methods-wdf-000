class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    opening = Array.new
    self.listings.each do |l|
      a = l.reservations.any?{|r| date1 <= r.checkout.to_s && date2 >= r.checkin.to_s} # overlap
      opening << l if a == false #only add if there is no overlap
    end
    opening
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood|
      if neighborhood.reservations.size > 0 && neighborhood.listings.size > 0  
        (neighborhood.reservations.size.to_f)/(neighborhood.listings.size.to_f)
      else
        0
      end
    end
  end

  def self.most_res
    self.all.max_by{|neighborhood| neighborhood.reservations.size}
  end

end

