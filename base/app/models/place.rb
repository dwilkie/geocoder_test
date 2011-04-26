class Place < ActiveRecord::Base
  geocoded_by :address do |obj,results|
    if geo = results.first
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
    end
  end
  after_validation :fetch_coordinates
end
