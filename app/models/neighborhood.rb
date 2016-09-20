class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_opening
  end


  def self.highest_ratio_res_to_listings
    # ratios = []
    # binding.pry

    highest_ratio = 0
    highest_n = nil
    self.all.each do |n|
      #  binding.pry

       if !n.ratio_res_to_listings.nil? && n.ratio_res_to_listings > highest_ratio

         highest_ratio = n.ratio_res_to_listings
         highest_n = n
       end
     end
      # city.ratio = city.ratio_res_to_listings
    highest_n

  end

  def reservations_sum
    num = []
    self.listings.each do |l|
      num << l.reservations.count
    end

    num.sum
  end

  def listings_count
    self.listings.count
  end

  def ratio_res_to_listings
    reservations_sum / listings_count if listings_count != 0
    # binding.pry
  end


  def self.most_res
    most_res = 0
    most_res_city = nil

    self.all.each do |c|
      if c.res_count > most_res && !c.res_count.nil?
        most_res = c.res_count
        most_res_city = c
      end
    end

    most_res_city
  end



  def res_count
    listings_rsvp = []
    self.listings.each do |l|
      listings_rsvp << l.reservations.count
    end
    listings_rsvp.sum
    # binding.pry
  end

  def neighborhood_openings(date_1, date_2)
    city_options = self.city.city_openings(date_1, date_1)
    neighborhood_listings = []

    city_options.each do |listing|
      if listing.neighborhood_id == self.id
        neighborhood_listings << listing
        # binding.pry

      end
    end

    neighborhood_listings
  end

end
