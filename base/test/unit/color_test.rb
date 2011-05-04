require 'test_helper'

class ColorTest < ActiveSupport::TestCase

  test "associations" do
    assert_equal [venues(:beacon)], colors(:red).venues
  end
end
