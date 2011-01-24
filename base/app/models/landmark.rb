class Landmark < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude
  after_validation :fetch_address
end

