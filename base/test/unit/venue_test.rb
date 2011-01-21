require 'test_helper'

class VenueTest < ActiveSupport::TestCase

  test "fetch coordinates" do
    v = Venue.new(
      :name => "Madison Square Garden",
      :address => "4 Penn Plaza, New York, NY"
    )
    v.fetch_coordinates
    assert_not_nil v.latitude
    assert_not_nil v.longitude
    assert (v.latitude - 40.75).abs < 0.01
    assert (v.longitude - -73.99).abs < 0.01
  end

  test "finds venues near a point" do
    assert Venue.near(hempstead_coords, 15).include?(venues(:nikon))
  end

  test "don't find venues not near a point" do
    assert !Venue.near(hempstead_coords, 5).include?(venues(:forum))
  end

  test "find all venues near another venue" do
    assert venues(:nikon).nearbys(40).include?(venues(:beacon))
    assert venues(:beacon).nearbys(40).include?(venues(:nikon))
  end

  test "don't find venues not near another venue" do
    assert !venues(:nikon).nearbys(10).include?(venues(:forum))
    assert !venues(:forum).nearbys(10).include?(venues(:beacon))
  end

  test "don't include self in nearbys" do
    assert !venues(:nikon).nearbys(5).include?(venues(:nikon))
  end

  test "select options" do
    forum = venues(:forum)
    venues = Venue.near(hollywood_coords, 20,
      :select => "*, latitude * longitude AS junk")
    assert venues.first.junk.to_f - (forum.latitude * forum.longitude) < 0.1
  end

  # TODO: test limit, order, offset, exclude, and units arguments


  private # ------------------------------------------------------------------

  ##
  # Coordinates of Hempstead, Long Island, NY, about 8 miles from Jones Beach.
  #
  def hempstead_coords
    [40.7062128, -73.6187397]
  end

  ##
  # Coordinates of Hollywood, CA, about 10 miles from The Great Western Forum.
  #
  def hollywood_coords
    [34.09833, -118.32583]
  end
end
