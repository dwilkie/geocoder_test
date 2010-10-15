class Venue < ActiveRecord::Base
  geocoded_by :address
  after_validation :fetch_coordinates
end
