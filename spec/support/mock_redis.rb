RSpec.configure do |config|
  config.before(:each) do
    $redis = MockRedis.new
    $redis.flushall
  end
end
