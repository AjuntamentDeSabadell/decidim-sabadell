# -*- coding: utf-8 -*-
# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Sabadell"
  config.mailer_sender    = "decidim@codegram.com"
  config.authorization_handlers = []

  # Uncomment this lines to set your preferred locales
  # config.available_locales = %i{en ca es}

  # Geocoder configuration
  # config.geocoder = {
  #   here_app_id: Rails.application.secrets.geocoder["here_app_id"],
  #   here_app_code: Rails.application.secrets.geocoder["here_app_code"]
  # }

  # Currency unit
  # config.currency_unit = "€"
end
