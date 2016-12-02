class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  after_create :change_host_status
  after_destroy :change_host_status_to_false

  def average_review_rating
    result = self.reviews.average(:rating)
    result = "%.1f" % result
    result.to_f
  end

  def openings(start_date, end_date)
    self.reservations.where("checkout < start_date OR checkin > end_date")
  end

  private

  def change_host_status
   self.host.update(host: true)
  end

  def change_host_status_to_false
   self.host.update(host: false) if self.host.listings.size == 0
  end

end
