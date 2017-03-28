Rails.application.routes.draw do
  if Rails.env.production?
    require 'sidekiq/web'
    authenticate :user, lambda { |u| u.roles.include?("admin") } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  mount Decidim::Core::Engine => '/'
end
