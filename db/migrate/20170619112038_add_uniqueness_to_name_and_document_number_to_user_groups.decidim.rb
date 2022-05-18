# This migration comes from decidim (originally 20170612070905)
# frozen_string_literal: true

class AddUniquenessToNameAndDocumentNumberToUserGroups < ActiveRecord::Migration[5.0]
  def change
    fix_field(:document_number)
    fix_field(:name)

    add_index :decidim_user_groups, [:decidim_organization_id, :name], unique: true, name: "index_decidim_user_groups_names_on_organization_id"
    add_index :decidim_user_groups, [:decidim_organization_id, :document_number], unique: true, name: "index_decidim_user_groups_document_number_on_organization_id"
  end

  def fix_field(field_name)
    # Decidim::UserGroup.select(field_name).group(field_name).having("count(*) > 1").count.keys.each do |value|
    #   Decidim::UserGroup.where(field_name => value).each_with_index do |user_group, index|
    #     next if index.zero?
    #     user_group.update_attribute(field_name, "#{value} (#{index})")
    #   end
    # end
  end
end
