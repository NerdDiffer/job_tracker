# grab settings from `config/redis.yml`
config_file_path = Rails.root.join('config', 'redis.yml')

# store all configuration in a hash
REDIS_CONFIG = YAML.load(File.open(config_file_path)).symbolize_keys

default = REDIS_CONFIG[:default].symbolize_keys
env = Rails.env.to_sym

if env == :production
  uri = ENV['REDISTOGO_URL']
  config = { :url => uri, :driver => :hiredis }
elsif REDIS_CONFIG[env]
  config = default.merge(REDIS_CONFIG[env].symbolize_keys)
end

$redis = Redis.new(config)

# To clear out the db before each test
$redis.flushdb if env == :test

# old setup starts here:
#uri = ENV['REDISTOGO_URL'] || "redis://localhost:6379"
#$redis = Redis.new(:url => uri, :driver => :hiredis)
