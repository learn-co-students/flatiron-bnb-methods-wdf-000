class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :change_user_host_status
  after_destroy :change_user_host_status
  
  def average_review_rating
    # ratings = self.reviews.collect{|review| review.rating}
    # ratings.inject{|sum, rating| sum + rating}.to_f / ratings.size
    self.reviews.average(:rating)
  end

  private

    def change_user_host_status
      if self.host.listings.empty?
        self.host.update(host: false)
      else
        self.host.update(host: true)
      end
    end


end