class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

   def neighborhood_openings(start, finish)
     Listing.all.each do |listing|
       listing.reservations.where("reservations.checkin != #{start} AND reservations.checkout != #{finish}")
   end
 end

 def self.highest_ratio_res_to_listings
   sql = "SELECT neighborhoods.id FROM neighborhoods WHERE neighborhoods.id = (
   SELECT listings.neighborhood_id FROM listings WHERE listings.id = (
     SELECT reservations.d FROM (
       SELECT reservations.listing_id as d, MAX(reservations.c)
     FROM (SELECT reservations.listing_id, COUNT(reservations.listing_id) AS c FROM reservations) reservations
     ) reservations ) )
   "
   record_hash = ActiveRecord::Base.connection.execute(sql).first
   Neighborhood.find(record_hash.values.first)
 end

 def self.most_res
   sql = "SELECT neighborhoods.id FROM neighborhoods WHERE neighborhoods.id = (
   SELECT listings.neighborhood_id FROM listings WHERE listings.id = (
     SELECT reservations.d FROM (
       SELECT reservations.listing_id as d
     FROM (SELECT reservations.listing_id, COUNT(reservations.listing_id) AS c FROM reservations ORDER BY c DESC LIMIT 1) reservations
     ) reservations ) )
   "
     record_hash = ActiveRecord::Base.connection.execute(sql).first
     Neighborhood.find(record_hash.values.first)
 end
end
