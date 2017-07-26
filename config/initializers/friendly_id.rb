FriendlyId.defaults do |config|
  config.use :reserved

  config.reserved_words = %w(new edit index stylesheets assets javascripts
    images)
end
