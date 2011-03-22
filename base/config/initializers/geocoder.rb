Geocoder::Configuration.timeout = 4
Geocoder::Configuration.lookup = :yahoo
Geocoder::Configuration.cache = Redis.new
Geocoder::Configuration.cache_prefix = "geocoder-test:"
