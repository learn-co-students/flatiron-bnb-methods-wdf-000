class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_save :set_host
  before_destroy :remove_host

  def average_review_rating
    counter = 0.0
    self.reviews.each do |review|
      counter += review.rating
    end
    counter/self.reviews.count
  end

  private

  def set_host
    unless host.host?
      host.update(:host => true)
    end
  end

  def remove_host
    if host.listings.length <= 1
      unless !host.host?
        host.update(:host => false)
      end
    end
  end

end
