class Venue < ActiveRecord::Base
  belongs_to :color
  geocoded_by :address
  after_validation :fetch_coordinates
end
