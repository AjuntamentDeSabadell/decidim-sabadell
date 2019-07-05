# frozen_string_literal: true
# This migration comes from decidim_meetings (originally 20181107175558)

class AddQuestionnaireToExistingMeetings < ActiveRecord::Migration[5.2]
  def change
    Decidim::Meetings::Meeting.transaction do
      Decidim::Meetings::Meeting.find_each do |meeting|
        next unless meeting.component && meeting.component.participatory_space

        if meeting.component.present? && meeting.questionnaire.blank?
          meeting.update!(
            questionnaire: Decidim::Forms::Questionnaire.new
          )
        end
      end
    end
  end
end
