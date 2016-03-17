class Application < Rails::Application
  config.before_configuration do
    rails_env = Rails.env
    env_file_name = Rails.root.join('config', 'env_vars.yml').to_s

    if rails_env != 'production' && File.exist?(env_file_name)
      env_file = YAML.load_file(env_file_name)
      keys = env_file[rails_env]
      keys.each { |key, val| ENV[key.to_s] = val }
    end
  end
end
