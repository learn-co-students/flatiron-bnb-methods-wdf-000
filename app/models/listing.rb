class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :title, :listing_type, :description, :price, :neighborhood_id, presence: true
  after_save :change_user_status
  before_destroy :unset_host_as_host

  def average_review_rating
    sum = 0 
    self.reviews.each { |review| sum += review.rating }
    sum/reviews.size.to_f
  end

  private

  def unset_host_as_host
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end

  def change_user_status
    host.update(host: true)
  end

end
