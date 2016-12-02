class City < ActiveRecord::Base
  include Checkable::InstanceMethods
  extend Checkable::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  # has_many :reservations, through: :listings

  # collects listings that dont have conflicts
  def city_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

end
