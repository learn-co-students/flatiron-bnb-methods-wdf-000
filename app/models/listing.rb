class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true


  after_create  :flip_host_status
  after_destroy :flip_host_status


  def average_review_rating
    self.reviews.average(:rating)
  end

private

  def flip_host_status
    self.host.listings.empty? ? self.host.update(:host => false) : self.host.update(:host => true)
  end


end
