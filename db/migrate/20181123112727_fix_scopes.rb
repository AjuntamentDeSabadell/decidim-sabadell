class FixScopes < ActiveRecord::Migration[5.2]
  def change
    Decidim::Scope.find_each do |scope|
     scope.send(:update_part_of)
     scope.save!
    end
  end
end
