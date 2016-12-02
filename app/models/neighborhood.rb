class Neighborhood < ActiveRecord::Base
  include Checkable::InstanceMethods
  extend Checkable::ClassMethods

  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

end
