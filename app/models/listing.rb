class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :title, :listing_type, :description, :price, :neighborhood
  after_create :make_host
  after_destroy :remove_host

  def available?(start_date, end_date)
    reservations.none? do |r|
      booking_dates = r.checkin..r.checkout
      booking_dates === start_date || booking_dates === end_date
    end
  end

  def make_host
    user = User.find(host_id)
    user.host = true
    user.save
  end

  def remove_host
    user = User.find(host_id)
    if user.listings.empty?
      user.host = false
      user.save
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
