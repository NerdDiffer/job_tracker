module EnvVars
  class Application < Rails::Application
    config.before_configuration do
      env_file_name = Rails.root.join('config', 'env_vars.yml').to_s

      if File.exists?(env_file_name)
        env_file = YAML.load_file(env_file_name)
        env = Rails.env
        keys = env_file[env]
        keys.each { |key, val| ENV[key.to_s] = val }
      end
    end
  end
end
