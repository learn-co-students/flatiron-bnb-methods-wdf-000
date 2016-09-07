class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # collects listings that dont have conflicts
  def city_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

  private

  def reservation_check(listing, start_date, end_date)
    listing.reservations.collect do |r|
      r if (Date.parse(start_date) <= r.checkout) and (Date.parse(end_date) >= r.checkin)
    end
  end

end

