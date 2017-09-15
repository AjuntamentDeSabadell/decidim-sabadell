# -*- coding: utf-8 -*-
# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Sabadell"
  config.mailer_sender    = "Decidim Sabadell <decidim@sabadell.cat>"
  config.authorization_handlers = [CensusAuthorizationHandler]

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca es}
  config.default_locale = :ca

  # Geocoder configuration
  config.geocoder = {
    static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
    here_app_id: Rails.application.secrets.geocoder[:here_app_id],
    here_app_code: Rails.application.secrets.geocoder[:here_app_code]
  }

  # Currency unit
  config.currency_unit = "€"
end
