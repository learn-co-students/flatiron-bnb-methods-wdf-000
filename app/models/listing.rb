class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :title, :description, :address, :listing_type, :price
  validates_presence_of :neighborhood, numericality: { only_integer: true}
end
