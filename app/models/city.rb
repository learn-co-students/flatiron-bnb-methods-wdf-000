class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_1, date_2)
    available = []
    uniq = []
    self.listings.each do |l|
      if l.reservations.empty?
        available << l
      else
        l.reservations.each do |r|
        # binding.pry

          if (date_1.to_date > r.checkin && date_2.to_date > r.checkin) || (date_1.to_date < r.checkin && date_2.to_date <= r.checkin)

            available << r.listing
          end
        end
      end
    end

    available.uniq

    # binding.pry
  end

  def self.highest_ratio_res_to_listings
    # ratios = []

    highest_ratio = 0
    highest_city = nil
    self.all.each do |city|
       if city.ratio_res_to_listings > highest_ratio
         highest_ratio = city.ratio_res_to_listings
         highest_city = city
       end
     end
      # city.ratio = city.ratio_res_to_listings
    highest_city
    # binding.pry

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
    reservations_sum / listings_count
  end


  def self.most_res
    most_res = 0
    most_res_city = nil

    self.all.each do |c|
      if c.res_count > most_res
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

end
