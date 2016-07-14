class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_save :make_host
  before_destroy :unmake_host

  def average_review_rating
    (reviews.map{|review| review.rating}.inject{|sum,i| sum + i} / reviews.length).round(1)
  end

  private

  def make_host
    self.host.update(host: true)
  end

  def unmake_host
    self.host.update(host: false) if self.host.listings.length == 1
  end
end
