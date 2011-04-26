require 'test_helper'

class PlaceTest < ActiveSupport::TestCase

  def setup
    Geocoder::Configuration.lookup = :google
    Geocoder::Configuration.cache = nil
  end

  def test_sti_child_can_access_parent_config
    assert_not_nil Temple.geocoder_options
  end

  def test_sti_child_geocoding_works
    a = Arena.new(
      :name => "Mellon Arena",
      :address => "66 Mario Lemieux Place, Pittsburgh, PA")
    a.geocode
    assert_not_nil a.latitude
  end
end
