server 'sul-quimby-stage.stanford.edu', user: 'quimby', roles: %w{app db web}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
