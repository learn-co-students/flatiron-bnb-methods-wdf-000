class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, :presence => true

  before_create :host_available
  after_destroy :host_not_available

  def average_review_rating
    self.reviews.average(:rating)
  end

  def host_available
    self.host.update(host: true)
  end

  def host_not_available
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end
end
