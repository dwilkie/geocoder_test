require 'test_helper'

class VenuesControllerTest < ActionController::TestCase

  test "request location returns Geocoder::Result::Freegeoip" do
    get :index
    assert @request.location.kind_of?(Geocoder::Result::Freegeoip)
    assert_equal "0.0.0.0", @request.location.ip
    assert_equal "Reserved", @request.location.country
  end
end
