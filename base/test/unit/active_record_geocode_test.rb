require 'test_helper'

class ActiveRecordGeocodeTest < ActiveSupport::TestCase

  test "fetch coordinates when address supplied" do
    e = Event.new(
      :name => "Madison Square Garden",
      :address => "4 Penn Plaza, New York, NY"
    )
    e.fetch_coordinates
    assert_not_nil e.latitude
    assert_not_nil e.longitude
  end

  test "fetch address when coordinates supplied" do
    e = Event.new(
      :name => "Madison Square Garden",
      :latitude => 40.75055,
      :longitude => -73.9936
    )
    e.reverse_geocode
    assert_not_nil e.address
  end

  test "lookup with blank address" do
    v = Venue.new(:name => "Haunted House", :address => "")
    assert_nothing_raised { v.fetch_coordinates }
  end

  test "lookup with bad address" do
    v = Venue.new(:name => "Haunted House", :address => ", , , ")
    assert_nothing_raised { v.fetch_coordinates }
  end

  test "lookup coordinates with space after comma" do
    assert_not_equal [], Geocoder.search("50.2, -88.7")
  end

  test "fetch address" do
    v = Landmark.new(
      :name => "Mount Rushmore",
      :latitude => 43.88,
      :longitude => -103.46
    )
    v.fetch_address
    assert_not_nil v.address
  end
end
