# load up the app config

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
