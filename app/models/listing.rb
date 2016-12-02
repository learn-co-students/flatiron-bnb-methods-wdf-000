class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :host_true
  before_destroy :host_false
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  def is_available?(date_1, date_2)
    !self.reservations.find do |reservation|
      (reservation.checkin..reservation.checkout).overlaps?(date_1..date_2)
    end
  end

  def host_true
    if self.host
      self.host.host = true
      self.host.save
    end
  end

  def host_false
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    sum = 0
    self.reviews.each do |review|
      sum += review.rating
    end
    (sum * 1.0) / self.reviews.count
  end

end
