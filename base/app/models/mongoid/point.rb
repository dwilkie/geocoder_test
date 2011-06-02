class Point
  include Mongoid::Document
  field :name
  field :address
  field :country
  field :coordinates, :type => Array

  include Geocoder::Model::Mongoid
  reverse_geocoded_by :coordinates do |obj,rs|
    if r = rs.first
      obj.address = r.address
      obj.country = r.country_code
    end
  end
  after_validation :reverse_geocode
end

