class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :host_status?
  after_destroy :host_delete


  def average_review_rating
    avg = self.reviews.collect{|review| review.rating}
    avg.inject{ |sum, next_num| sum + next_num }.to_f / avg.size
  end

  private

  def host_status?
    if self.host
      self.host.host = true
      self.host.save
    end
  end

  def host_delete
    if self.host.listings.size == 0
      self.host.host = false
      self.host.save
    end
  end

end
