class Listing < ActiveRecord::Base

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  validates :address, presence: true
  validates :listing_type, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :neighborhood, presence: true

  # before_create :host_reload
  after_save :host_reload

  after_destroy :reset_host_to_user

  def average_review_rating
    ratings = []
    result = 0
    self.reservations.each do |res|
      # binding.pry
        ratings << res.review.rating if !res.review.rating.nil?
    end

    if !ratings.empty?
      result = (ratings.sum).to_f / (ratings.size).to_f
      # binding.pry
    end

      result
      # binding.pry
  end



  private

    def host_reload
      host = User.find_by_id(self.host_id)
      # binding.pry
      host.update(:host => true)
      # binding.pry
    end

    def reset_host_to_user
      host = User.find_by_id(self.host_id)
      if host.listings.empty?
        host.update(:host => false)
      end

      # binding.pry
    end



end
