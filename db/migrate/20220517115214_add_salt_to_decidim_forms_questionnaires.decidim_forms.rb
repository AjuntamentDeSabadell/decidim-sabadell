# frozen_string_literal: true
# This migration comes from decidim_forms (originally 20201110152921)

class AddSaltToDecidimFormsQuestionnaires < ActiveRecord::Migration[5.2]
  class Questionnaire < ApplicationRecord
    self.table_name = :decidim_forms_questionnaires
  end

  def change
    add_column :decidim_forms_questionnaires, :salt, :string

    Questionnaire.find_each do |questionnaire|
      custom_salt = questionnaire.id > 99 ? "3acd7793f2a8cbeb91ebe31c#{questionnaire.id}4921f71f83d2d2b73009fa8494e260d54c" : questionnaire.id > 9 ? "3acd7793f2a873b91ebe431a#{questionnaire.id}4921f71cbed2d2bf83009fa8494e260d54c" : "2a8cbed20d2b73b91eb3acd7793fe431t#{questionnaire.id}4921f71f83009fa8494e260d54c"
      questionnaire.salt = custom_salt
      #questionnaire.salt = Decidim::Tokenizer.random_salt
      questionnaire.save!
    end
  end
end
