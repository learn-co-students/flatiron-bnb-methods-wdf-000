class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings
  include Concerns::InstanceMethods
  extend Concerns::ClassMethods
end
