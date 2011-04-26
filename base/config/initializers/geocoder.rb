Geocoder::Configuration.timeout = 4
Geocoder::Configuration.lookup = :yahoo
Geocoder::Configuration.cache = Redis.new
Geocoder::Configuration.cache_prefix = "geocoder-test:"
#Geocoder::Configuration.api_key = "AK9YsE0BAAAAJSfSIQIAXY-hKMoXFMmhNt2ODpY9aIj1xjgAAAAAAAAAAAC2oUtoBbEFWTj_lhO3qppCluacmQ==" # yandex
#Geocoder::Configuration.api_key = "AkF2UQXrWxyzqG7d2L3e78V_PGiJL7iOXLRu04Nd8s9hFd0P82azwwHX4gAcIbny" # bing
