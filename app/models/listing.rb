class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address
  validates_presence_of :listing_type
  validates_presence_of :description
  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :neighborhood

  after_save :set_host
  before_destroy :unset_host


  def average_review_rating
    avg = self.reviews.collect { |review| review.rating }
      avg.inject{|sum, sum2| sum + sum2 }.to_f / avg.count
  end


  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).where.not(reservations: {check_in: start_date..end_date}) & joins(:reservations).where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

  private

    def set_host
      if self.host
        self.host.host = true
        self.host.save
      end
    end

    def unset_host
      if self.host.listings.count == 1
        self.host.host = false
        self.host.save
      end
    end

end
