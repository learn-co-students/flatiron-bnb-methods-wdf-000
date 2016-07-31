class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations 
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :neighborhood, presence: true
  validates :listing_type, presence: true

  before_create :change_host_status
  after_destroy :check_and_change_host_status_on_destroy

  def average_review_rating
    reviews.map {|review| review.rating}.reduce(:+) / reviews.count.to_f
  end
  
  def change_host_status
    self.host.update(host: true)
  end

  def check_and_change_host_status_on_destroy
    self.host.update(host: false) if self.host.listings.count == 0
  end
end
