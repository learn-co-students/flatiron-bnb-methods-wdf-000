class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  before_create :host?
  after_destroy :destroy_

  def average_review_rating
    sum = 0
    rep = 0
    self.reservations.each do |r|
      sum += r.review.rating
      rep += 1
    end
    sum.to_f/rep.to_f
  end


  private

  def destroy_
    if self.host.listings.size == 0
      self.host.host = false
      self.host.save
    end
  end

  def host?
    if self.id == nil
      self.host.host = true
      self.host.save 
    end
  end


end
