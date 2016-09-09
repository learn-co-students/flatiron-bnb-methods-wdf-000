class Neighborhood < ActiveRecord::Base
  include Checkable::InstanceMethods
  belongs_to :city
  has_many :listings

  # collects listings that dont have conflicts
  def neighborhood_openings(start_date, end_date)
    self.listings.collect do |listing|
      listing if reservation_check(listing, start_date, end_date).all? {|r| r == nil}
    end
  end

end
