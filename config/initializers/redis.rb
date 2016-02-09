config_file_path = Rails.root.join('config', 'redis.yml')
config_file = File.open(config_file_path)
REDIS_CONFIG = YAML.load(config_file).symbolize_keys
env = Rails.env.to_sym

if env == :production
  config = {
    url: ENV['REDISTOGO_URL'],
    driver: :hiredis
  }
elsif REDIS_CONFIG[env]
  default = REDIS_CONFIG[:default].symbolize_keys
  config  = default.merge(REDIS_CONFIG[env].symbolize_keys)
end

$redis = Redis.new(config)

# Clear out db before each test
$redis.flushdb if env == :test

# old setup starts here:
#uri = ENV['REDISTOGO_URL'] || "redis://localhost:6379"
#$redis = Redis.new(:url => uri, :driver => :hiredis)
