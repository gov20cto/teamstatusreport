# load up the app config

APP_CONFIG = YAML.load(ERB.new(File.new("#{RAILS_ROOT}/config/config.yml").read).result)[RAILS_ENV]
