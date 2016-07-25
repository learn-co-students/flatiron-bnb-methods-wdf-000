class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations 
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :change_host_status
  after_destroy :change_host_status_for_destroy

  def average_review_rating
    self.reviews.inject(0.0) { |sum, review| sum += review.rating } / self.reviews.count
  end

  private
  def change_host_status
    # user = User.find(self.host_id)
    # user.update(host: user.host ? false : true)
    self.host.update(host: self.host.host ? false : true)
  end

  def change_host_status_for_destroy
    # user = User.find(self.host_id)
    self.host.update(host: false) unless self.host.listings.count > 0
  end

end
