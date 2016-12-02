class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :host_status
  after_destroy :destroy_status


  def average_review_rating
  	arr = []
  	self.reviews.collect do |review| 
  		if review.rating != nil
  			arr << review.rating 
  		end
  	end
  	arr.sum.to_f/arr.count.to_f
  end

  private

  def host_status
  	self.host.host = true
  	self.host.save
  end

  def destroy_status
   if self.host.listings.empty?
   		self.host.host = false
   		self.host.save
   	end
  end


end
