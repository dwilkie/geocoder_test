require 'test_helper'

class EventTest < ActiveSupport::TestCase

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
end
