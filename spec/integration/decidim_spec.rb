require "rails_helper"

describe "Decidim integration", type: :feature do
  before do
    CarrierWave.configure { |c| c.enable_processing = true }
    Decidim.seed!
    Decidim::Organization.first.update_attribute(:host, Capybara.default_host.gsub("http://", ""))
    CarrierWave.configure { |c| c.enable_processing = false }
  end

  it "loads Decidim" do
    visit decidim.root_path
    expect(page).to have_content(Decidim::Organization.first.name)
    expect(page).to have_content("Participa")
  end
end
