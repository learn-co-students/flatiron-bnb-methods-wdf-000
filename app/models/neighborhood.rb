class Neighborhood < ActiveRecord::Base
  include Checkable::InstanceMethods

  belongs_to :city
  has_many :listings

end
