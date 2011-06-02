require 'test_helper'

class ActiveRecordTest < ActiveSupport::TestCase

  def setup
    Geocoder::Configuration.lookup = :google
    Geocoder::Configuration.cache = nil
  end

  test "associations" do
    assert_equal [venues(:beacon)], colors(:red).venues
  end

  test "geocoded and not geocoded scopes" do
    Venue.create(:name => "Turd Hall")
    assert_equal 3, Venue.geocoded.count
    assert_equal 1, Venue.not_geocoded.count
  end


  # --- single table inheritance ---

  test "sti child can access parent config" do
    assert_not_nil Temple.geocoder_options
  end

  test "sti child geocoding works" do
    a = Arena.new(
      :name => "Mellon Arena",
      :address => "66 Mario Lemieux Place, Pittsburgh, PA")
    a.geocode
    assert_not_nil a.latitude
  end


  # --- distance ---

  test "distance of found points" do
    leeway = sqlite? ? 2 : 1
    distance = 9
    nearbys = Venue.near(hempstead_coords, 15)
    nikon = nearbys.detect{ |v| v.id == Fixtures.identify(:nikon) }
    assert (distance - nikon.distance).abs < leeway,
      "Distance should be close to #{distance} miles but was #{nikon.distance}"
  end

  test "distance of found points in kilometers" do
    leeway = sqlite? ? 2 : 1
    distance = 14.5
    nearbys = Venue.near(hempstead_coords, 25, :units => :km)
    nikon = nearbys.detect{ |v| v.id == Fixtures.identify(:nikon) }
    assert (distance - nikon.distance).abs < leeway,
      "Distance should be close to #{distance} miles but was #{nikon.distance}"
  end


  # --- bearing ---

  test "bearing (linear) of found points" do
    leeway = sqlite? ? 45 : 2
    bearing = 137
    nearbys = Venue.near(hempstead_coords, 15, :bearing => :linear)
    nikon = nearbys.detect{ |v| v.id == Fixtures.identify(:nikon) }
    assert (bearing - nikon.bearing).abs < leeway,
      "Bearing should be close to #{bearing} degrees but was #{nikon.bearing}"
  end

  test "bearing (spherical) of found points" do
    leeway = sqlite? ? 45 : 2
    bearing = 144
    nearbys = Venue.near(hempstead_coords, 15, :bearing => :spherical)
    nikon = nearbys.detect{ |v| v.id == Fixtures.identify(:nikon) }
    assert (bearing - nikon.bearing).abs < leeway,
      "Bearing should be close to #{bearing} degrees but was #{nikon.bearing}"
  end

  test "don't calculate bearing" do
    nearbys = Venue.near(hempstead_coords, 15, :bearing => false)
    nikon = nearbys.detect{ |v| v.id == Fixtures.identify(:nikon) }
    assert_raises(NoMethodError) { nikon.bearing }
  end


  # --- near ---

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
    # this also tests the :exclude option to the near method
    assert !venues(:nikon).nearbys(5).include?(venues(:nikon))
  end

  test "near method select option" do
    forum = venues(:forum)
    venues = Venue.near(hollywood_coords, 20,
      :select => "*, latitude * longitude AS junk")
    assert venues.first.junk.to_f - (forum.latitude * forum.longitude) < 0.1
  end

  test "near method units option" do
    assert_equal 2, Venue.near(hempstead_coords, 25, :units => :mi).length
    assert_equal 1, Venue.near(hempstead_coords, 25, :units => :km).length
  end

  test "compatible with other scopes" do
    assert_equal venues(:beacon), Venue.near(hempstead_coords, 25).limit(1).offset(1).first
  end


  private # ------------------------------------------------------------------

  def sqlite?
    ActiveRecord::Base.connection.adapter_name.match(/sqlite/i)
  end

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
