class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    listings.find_all { |l| l.available?(start_date, end_date) }
  end

  def self.highest_ratio_res_to_listings
    all.max_by do |neighborhood|
      if neighborhood.listings.count == 0
        0
      else
        (neighborhood.reservations.count)/(neighborhood.listings.count)
      end
    end
  end

  def self.most_res
    all.max_by {|neighborhood| neighborhood.reservations.count}
  end

end
