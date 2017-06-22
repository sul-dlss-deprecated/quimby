set :output, 'log/quimby_cron.log'

every 2.hours do
  rake 'load_data:all'
end
