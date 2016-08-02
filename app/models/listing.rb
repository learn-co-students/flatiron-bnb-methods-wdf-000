class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :make_host
  before_destroy :remove_host

  def make_host
    host.host = true
    host.save
  end

  def remove_host
    host.host = false if host.listings.size == 1
    host.save
  end

  def average_review_rating
    (reviews.map{|review| review.rating}.inject(0, :+)) / reviews.count.to_f
  end



end
