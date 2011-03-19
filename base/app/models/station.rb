class Station
  include Mongoid::Document
  field :name
  field :address
  field :coordinates, :type => Array

  include Geocoder::Model::Mongoid
  geocoded_by :address
end

