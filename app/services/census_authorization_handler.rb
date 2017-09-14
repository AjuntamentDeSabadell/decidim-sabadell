# frozen_string_literal: true
# Checks the authorization against the census for Terrassa.
require "digest/md5"

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  attribute :document_number, String
  attribute :document_type, Symbol
  attribute :date_of_birth, Date

  validates :date_of_birth, presence: true
  validates :document_type, inclusion: { in: %i(dni nie passport community_dni) }, presence: true
  validates :document_number, format: { with: /\A[A-z0-9]*\z/ }, presence: true

  validate :document_type_valid
  validate :over_16

  def self.from_params(params, additional_params = {})
    instance = super(params, additional_params)

    params_hash = hash_from(params)

    if params_hash["date_of_birth(1i)"]
      date = Date.civil(
        params["date_of_birth(1i)"].to_i,
        params["date_of_birth(2i)"].to_i,
        params["date_of_birth(3i)"].to_i
      )

      instance.date_of_birth = date
    end

    instance
  end

  def census_document_types
    %i(dni nie passport community_dni).map do |type|
      [I18n.t(type, scope: "decidim.census_authorization_handler.document_types"), type]
    end
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def sanitized_document_type
    case document_type&.to_sym
    when :dni
      1
    when :passport
      2
    when :nie
      3
    when :community_dni
      4
    end
  end

  def sanitized_date_of_birth
    @sanitized_date_of_birth ||= date_of_birth&.strftime("%d-%m-%Y")
  end

  def document_type_valid
    return nil if response.blank?

    errors.add(:document_number, I18n.t("census_authorization_handler.invalid_document")) unless response.xpath("//existeix").text == "true"
  end

  def response
    return nil if document_number.blank? ||
                  document_type.blank? ||
                  date_of_birth.blank?

    return @response if defined?(@response)

    response ||= Faraday.post Rails.application.secrets.census_url do |request|
      request.headers["Content-Type"] = "text/xml"
      request.body = request_body
    end

    @response ||= Nokogiri::XML(response.body).remove_namespaces!
  end


  def request_body
    @request_body ||= <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pad="http://padro.serveis.terrassa.cat/">
  <soapenv:Header/>
  <soapenv:Body>
    <pad:existeix>
    <tipusDocument>#{sanitized_document_type}</tipusDocument>
      <numDocument>#{sanitize document_number&.upcase}</numDocument>
      <dataNaixement>#{sanitized_date_of_birth}</dataNaixement>
      <usuari>#{census_username}</usuari>
      <clau>#{census_password}</clau>
    </pad:existeix>
  </soapenv:Body>
</soapenv:Envelope>
EOS
  end

  def over_16
    errors.add(:date_of_birth, I18n.t("census_authorization_handler.age_under_16")) unless age && age >= 16
  end

  def age
    return nil if date_of_birth.blank?

    now = Date.current
    extra_year = (now.month > date_of_birth.month) || (
      now.month == date_of_birth.month && now.day >= date_of_birth.day
    )

    now.year - date_of_birth.year - (extra_year ? 0 : 1)
  end

  def census_username
    Rails.application.secrets.census_username
  end

  def census_password
    Rails.application.secrets.census_password
  end
end
