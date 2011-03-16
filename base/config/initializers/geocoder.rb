Geocoder::Configuration.timeout = 4
Geocoder::Configuration.lookup = :yahoo
Geocoder::Configuration.yahoo_appid = "lFzlNdDV34GCXHOVbAV1s6iEiXQnlUOTR158RR9C_mof6MIi6.HchIhpJYPXzZYDz10-"
Geocoder::Configuration.cache = Redis.new
Geocoder::Configuration.cache_prefix = "geocoder-test:"
