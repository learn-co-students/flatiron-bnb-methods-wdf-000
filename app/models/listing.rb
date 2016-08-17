class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address,
                        :listing_type,
                        :title,
                        :description,
                        :price,
                        :neighborhood_id

  after_save :set_host
  after_destroy :unset_host

  def set_host
    host.update(host: true)
  end

  def unset_host
    host.update(host: false) if host.listings.count == 0
  end

  def average_review_rating
    reviews.inject(0.0) { |sum, review| sum += review.rating } / reviews.count
  end
end
