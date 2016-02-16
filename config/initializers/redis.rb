config_file_path = Rails.root.join('config', 'redis.yml')
config_file = File.open(config_file_path)
redis_config = YAML.load(config_file).symbolize_keys
env = Rails.env.to_sym

if env == :production
  config = {
    url: ENV['REDISTOGO_URL'],
    driver: :hiredis
  }
elsif redis_config[env]
  default = redis_config[:default].symbolize_keys
  config  = default.merge(redis_config[env].symbolize_keys)
end

REDIS_CLIENT = Redis.new(config)

# Clear out db before each test
REDIS_CLIENT.flushdb if env == :test
