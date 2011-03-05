require 'test_helper'

class VenuesControllerTest < ActionController::TestCase

  test "request location returns Geocoder::Result" do
    get :index
    assert @request.location.kind_of?(Geocoder::Result::Base)
  end
end
