class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    nabes = {}
    self.all.each do |nabe|
      nabes[nabe.name] = (nabe.reservations.count * 1.0) / nabe.listings.count
      if nabes[nabe.name].nan?
        nabes[nabe.name] = 0
      end
    end
    nabe = nabes.select {|k, v| v == nabes.values.max}.keys
    self.find_by(name: nabe)
  end

  def self.most_res
    nabes = {}
    self.all.each do |nabe|
      nabes[nabe.name] = nabe.reservations.count
    end
    nabe = nabes.select {|k, v| v == nabes.values.max}.keys
    self.find_by(name: nabe)
  end

  def neighborhood_openings(date_1, date_2)
    arr = []
    self.listings.each do |listing|
      avail = true
      listing.reservations.each do |reservation|
        if (reservation.checkin..reservation.checkout).overlaps?(date_1..date_2)
          avail = false
        end
      end
      arr << listing if avail == true
    end
    arr
  end
end
