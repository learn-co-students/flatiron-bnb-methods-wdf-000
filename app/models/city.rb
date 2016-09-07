class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |city|
      ratios[city] = reservations(city).to_f / city.listings.count
    end
    ratios.max_by {|k, v| v}.first
  end

  def self.most_res
    res_hash = {}
    City.all.each do |city|
      res_hash[city] = reservations(city)
    end
    res_hash.max_by {|k,v| v}.first
  end

  # collects listings that dont have conflicts
  def city_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

  private

  # do class methods only work with other class methods?

  def self.reservations(location)
    location.listings.collect {|l| l.reservations.count}.reduce(:+)
  end

  def reservation_check(listing, start_date, end_date)
    listing.reservations.collect do |r|
      r if (Date.parse(start_date) <= r.checkout) and (Date.parse(end_date) >= r.checkin)
    end
  end

end
