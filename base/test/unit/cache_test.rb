require 'test_helper'

class ActiveRecordTest < ActiveSupport::TestCase

  def setup
    Geocoder::Configuration.lookup = :google
    Geocoder::Configuration.cache = nil
  end

  test "new result stored on cache miss" do
    cache_stores.each do |store|
      Geocoder::Configuration.cache = store
      query = "4893 Clay St, San Francisco, CA"
      url   = Geocoder.send(:lookup, query).send(:query_url, query, false)
      cache = Geocoder.cache
      cache.expire(url)
      assert_nil cache[url]
      Geocoder.search(query)
      assert_not_nil cache[url]
      cache.expire(url)
    end
  end

  test "cache hit" do
    Geocoder::Configuration.lookup = :geocoder_ca # fake result format
    cache_stores.each do |store|
      Geocoder::Configuration.cache = store
      query = "4893 Clay St, San Francisco, CA"
      url   = Geocoder.send(:lookup, query).send(:query_url, query, false)
      cache = Geocoder.cache
      # manually set weird cache content
      cache[url] = "test({'latt':'4.44','longt':'5.55'});"
      result = Geocoder.search(query).first
      assert_equal "4.44", result.latitude.to_s
      assert_equal "5.55", result.longitude.to_s
      cache.expire(url)
    end
  end

  test "cache expiration" do
    cache_stores.each do |store|
      cache = Geocoder.cache
      url   = "http://a"
      cache[url] = "blah blah blah"
      assert cache.send(:urls).include?(url)
      cache.expire(url)
      assert !cache.send(:urls).include?(url)
    end
  end

  test "full cache expiration" do
    cache_stores.each do |store|
      cache = Geocoder.cache
      cache["http://a"] = "blah blah blah"
      cache["http://b"] = "blah blah blah"
      cache.expire(:all)
      assert_equal 0, cache.send(:keys).size
    end
  end

  private # ------------------------------------------------------------------

  ##
  # Array of supported cache stores to test.
  #
  def cache_stores
    [{}, Redis.new]
  end
end
