class Venue < ActiveRecord::Base
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :fetch_coordinates
end
