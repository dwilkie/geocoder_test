#Mongoid.configure do |config|
#  config.logger = Logger.new($stderr, :debug)
#end

##
# Geocoded model with custom coordinates field.
#
class Someplace
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  geocoded_by :address, :coordinates => :location
  field :name
  field :address
  field :location, :type => Array

  def initialize(name, address)
    super()
    write_attribute :name, name
    write_attribute :address, address
  end
end
