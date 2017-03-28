Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.roles.include?("admin") } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Decidim::Core::Engine => '/'
end
