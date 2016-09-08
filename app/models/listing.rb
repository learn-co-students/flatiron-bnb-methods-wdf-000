class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_save :toggle_host
  after_destroy :toggle_host

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
