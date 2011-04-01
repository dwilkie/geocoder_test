require 'test_helper'

class StationTest < ActiveSupport::TestCase

  def setup
    Station.delete_all
  end

  test "fetch and store coordinates" do
    s = Station.new(
      :name => "Madison Square Garden",
      :address => "4 Penn Plaza, New York, NY"
    )
    s.geocode
    assert_not_nil s.coordinates
  end

  test "lookup with blank address" do
    s = Station.new(:name => "Haunted House", :address => "")
    assert_nothing_raised { s.geocode }
  end

  test "lookup with bad address" do
    s = Station.new(:name => "Haunted House", :address => ", , , ")
    assert_nothing_raised { s.geocode }
  end

  test "scopes" do
    assert_equal 0, Station.geocoded.count
    assert_equal 0, Station.not_geocoded.count

    s = Station.create(:name => "Target Field", :address => "1 Twins Way, Minneapolis, MN")
    s.geocode; s.save
    assert_equal 1, Station.geocoded.count
    assert_equal 0, Station.not_geocoded.count

    s.coordinates = nil; s.save
    assert_equal 0, Station.geocoded.count
    assert_equal 1, Station.not_geocoded.count
  end

  test "finds only objects near a point" do
    load_fixtures
    results = Station.near(hempstead_coords, 15)
    assert_equal 1, results.count
    assert_equal stations(:nikon), results.first
  end

  test "don't find objects not near a point" do
    load_fixtures
    assert !Station.near(hempstead_coords, 5).include?(stations(:forum))
  end

  test "find all objects near another object" do
    load_fixtures
    assert stations(:nikon).nearbys(40).include?(stations(:beacon))
    assert stations(:beacon).nearbys(40).include?(stations(:nikon))
  end

  test "don't find objects not near another object" do
    load_fixtures
    assert !stations(:nikon).nearbys(10).include?(stations(:forum))
    assert !stations(:forum).nearbys(10).include?(stations(:beacon))
  end

  test "don't include self in nearbys" do
    load_fixtures
    assert !stations(:nikon).nearbys(5).include?(stations(:nikon))
  end

  test "near method units option" do
    load_fixtures
    assert_equal 2, Station.near(hempstead_coords, 25, :units => :mi).count
    assert_equal 1, Station.near(hempstead_coords, 25, :units => :km).count
  end

  test "compatible with other scopes" do
    load_fixtures
    assert_equal stations(:beacon), Station.near(hempstead_coords, 25).limit(1).offset(1).first
  end


  private # ------------------------------------------------------------------

  def load_fixtures
    Station.create(
      :name => "Beacon Theater",
      :address => "2124 Broadway, New York, NY",
      :coordinates => [-73.981318, 40.7805932]
    )
    Station.create(
      :name => "Nikon at Jones Beach Theater",
      :address => "Jones Beach, Wantagh, NY",
      :coordinates => [-73.5152381, 40.5962533]
    )
    Station.create(
      :name =>  "The Forum",
      :address => "3900 W. Manchester Blvd, Inglewood, CA",
      :coordinates => [-118.341868, 33.9583]
    )
  end

  def stations(handle)
    names = {
      :nikon => "Nikon at Jones Beach Theater",
      :beacon => "Beacon Theater",
      :forum => "The Forum",
    }
    Station.where(:name => names[handle]).first
  end

  ##
  # Array of supported cache stores to test.
  #
  def cache_stores
    [{}, Redis.new]
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
