class Listing < ActiveRecord::Base
  belongs_to :host, :class_name => "User" # fk host_id
  belongs_to :neighborhood # fk neighborhood_id
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_save :toggle_host
  after_destroy :toggle_host

  def average_review_rating
    self.reviews.average(:rating).to_f
  end

  private

  def toggle_host
    u = User.find_by(id: self.host_id)
    if u.host && u.listings.empty?
      u.update(host: false)
    else
      u.update(host: true)
    end
  end

end
