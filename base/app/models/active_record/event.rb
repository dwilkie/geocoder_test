class Event < ActiveRecord::Base
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode
  after_validation :reverse_geocode
end
