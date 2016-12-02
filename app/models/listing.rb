class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price , presence: true
  validates :neighborhood_id, presence: true
  before_destroy :host_destroy
  before_save :change_stat


  def average_review_rating
    self.reviews.average(:rating)
  end

  def change_stat
    if !self.host.host.present?
      self.host.host = true
      self.host.save
    end
  end

  def host_destroy
  if self.host.listings.count <= 1
    self.host.host = false
    self.host.save
  end
end

end
