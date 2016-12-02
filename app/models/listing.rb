class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :ratings, :through => :reviews
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  before_create :change_user_status_to_host
  before_destroy :user_status

  def average_review_rating
     reviews_count = self.reviews.count
     sum = 0
     self.reviews.each do |review|
      sum += review.rating 
     end
     average = sum.to_f / reviews_count
  end

  private

  def change_user_status_to_host
    user = self.host
    user.host = true
    user.save
  end

  def user_status
    user = self.host
    if user.listings.count == 1
       user.host = false
    else
      user.host = true
   end
   user.save
  end

end

