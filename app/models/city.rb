class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |city|
      ratios[city] = ratio_check(city)
    end
    ratios.max_by {|k, v| v}.first
  end

  def self.most_res
    reservations = {}
    City.all.each do |city|
      reservations[city] = city.listings.collect {|l| l.reservations.count}.reduce(:+)
    end
    reservations.max_by {|k,v| v}.first
  end

  # collects listings that dont have conflicts
  def city_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

  private

  # do class methods only work with other class methods?
  # ratio_check fails unless a class method
  def self.ratio_check(city)
    listings = city.listings.count
    reservations = city.listings.collect {|l| l.reservations.count}.reduce(:+)
    reservations.to_f / listings
  end

  def reservation_check(listing, start_date, end_date)
    listing.reservations.collect do |r|
      r if (Date.parse(start_date) <= r.checkout) and (Date.parse(end_date) >= r.checkin)
    end
  end

end

