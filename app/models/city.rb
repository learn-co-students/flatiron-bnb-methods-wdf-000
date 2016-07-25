class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    booked_listings = "select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= #{start_date} AND r.checkout <= #{end_date}"
    Listing.find_by_sql("select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (#{booked_listings})")

    # self.listings.joins(:reservations).where("reservations.checkin <= :start_date AND reservations.checkout <= :end_date", {start_date: start_date, end_date: end_date})
  end

  def ratio_res_to_listings
    if self.listings.count > 0
      self.reservations_count / self.listings.count
    end
  end

  def reservations_count
    if self.listings.count > 0
      self.listings.inject(0) { |sum, listing| sum += listing.reservations.count }
    end
  end

  def self.highest_ratio_res_to_listings
    City.all.max { |a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings }
  end

  def self.most_res
    City.all.max { |a, b| a.reservations_count <=> b.reservations_count }
  end


end
