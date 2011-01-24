require 'test_helper'

class LandmarkTest < ActiveSupport::TestCase

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
