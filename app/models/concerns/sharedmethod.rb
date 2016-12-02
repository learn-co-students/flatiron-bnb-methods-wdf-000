module Sharedmethod
  extend ActiveSupport::Concern

  included do
    has_many :listings
    has_many :reservations, :through => :listings
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      has_existed_listings = self.all.find_all{|model_el| !model_el.listings.empty?}
      has_existed_listings.max_by {|model_el| model_el.reservations.size/model_el.listings.size}
    end

    def most_res
      self.all.max_by {|model_el| model_el.reservations.size}
    end

  end

end