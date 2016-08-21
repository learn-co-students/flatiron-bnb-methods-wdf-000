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
  validates :neighborhood, presence: true

  after_create :change_status 
  after_destroy :status_off

  def change_status
    self.host.update(host:!host.host)
    self.save
  end

  def status_off
    self.host.update(host: false) if host.listings.count < 1
  end

  def average_review_rating
    (reviews.inject(0) {|sum, x| sum + x.rating}).fdiv(reviews.count) 
  end
end