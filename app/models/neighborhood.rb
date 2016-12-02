class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings 

  # extend Reserve::ClassMethods
  # include Reserve::InstanceMethods  

  def neighborhood_openings(start_date, end_date)
    self.listings.select {|l| l.reservations.where("checkout < start_date OR checkin > end_date")}
  end

  def self.highest_ratio_res_to_listings
    temp = 0
    result = []
      self.all.select do |n| 
        if n.ratio != nil && n.ratio > temp 
          result = n
          temp = n.ratio
        end
      end
    result
  end

  def self.most_res
    self.all.max {|a,b| a.reservations.size <=> b.reservations.size}
  end

  def ratio
    if reservations.size > 0 
      reservations.size / listings.size 
    end 
  end

end
