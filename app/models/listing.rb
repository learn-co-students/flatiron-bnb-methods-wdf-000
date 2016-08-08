class Listing < ActiveRecord::Base
  validates :address         , presence: true
  validates :listing_type    , presence: true
  validates :title           , presence: true
  validates :description     , presence: true
  validates :price           , presence: true
  validates :neighborhood_id , presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :status_toggle
  after_destroy :status_off

  def average_review_rating
    reviews.inject(0.to_f){|sum,x| sum+=x.rating}/reviews.count
  end

  def status_off
    host.update(host: false) if host.listings.count < 1
  end

  def status_toggle
    host.update(host:!host.host)
  end

end
