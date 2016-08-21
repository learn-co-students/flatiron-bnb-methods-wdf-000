class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :neighborhood_id, presence: true

  after_save :set_host
  before_destroy :unset_host

  def set_host
    host.host = true
    host.save
  end

  def unset_host
    if Listing.where(host: host).where.not(id: id).empty?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
