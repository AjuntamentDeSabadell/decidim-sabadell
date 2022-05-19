# frozen_string_literal: true
# This migration comes from decidim_forms (originally 20201110152921)

class AddSaltToDecidimFormsQuestionnaires < ActiveRecord::Migration[5.2]
  class Questionnaire < ApplicationRecord
    self.table_name = :decidim_forms_questionnaires
  end

  def change
    add_column :decidim_forms_questionnaires, :salt, :string

    Questionnaire.find_each do |questionnaire|
      custom_salt = questionnaire.id > 99 ? "3acd7793f2a8cbed2d2b73b91ebe31c#{questionnaire.id}4921f71f83009fa8494e260d54c" : questionnaire.id > 9 ? "3acd7793f2a8cbed2d2b73b91ebe431a#{questionnaire.id}4921f71f83009fa8494e260d54c" : "3acd7793f2a8cbed20d2b73b91ebe431t#{questionnaire.id}4921f71f83009fa8494e260d54c"
      questionnaire.salt = custom_salt
      questionnaire.save!
    end
  end
end
