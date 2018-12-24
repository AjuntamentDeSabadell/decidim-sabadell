# frozen_string_literal: true

# Checks the authorization against the census for Terrassa.
require 'digest/md5'

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper
  include Virtus::Multiparams

  attribute :document_number, String
  attribute :date_of_birth, Date

  validates :date_of_birth, presence: true
  validates :document_number, format: { with: /\A[A-z0-9]*\z/ }, presence: true

  validate :document_valid
  validate :check_age

  def unique_id
    Digest::MD5.hexdigest("#{document_number}#{sanitized_date_of_birth}").upcase
  end

  def metadata
    super.merge(
      neighborhood: response.xpath('//Info//Barri').children.text,
      sector: response.xpath('//Info//Sector').children.text,
      gender: response.xpath('//Info//Sexe').children.text,
      year_of_birth: date_of_birth.year
    )
  end

  private

  def sanitized_date_of_birth
    @sanitized_date_of_birth ||= date_of_birth&.strftime('%d-%m-%Y')
  end

  def document_valid
    return nil if response.blank?

    errors.add(:document_number, I18n.t('census_authorization_handler.invalid_document')) unless response.xpath('//NumRegistres').children.text == '1'
  end

  def response
    return nil if document_number.blank? ||
                  date_of_birth.blank?

    return @response if defined?(@response)

    response ||= Faraday.post 'http://srvapp.sabadell.net/WSDecidim/WSDecidim.asmx' do |request|
      request.headers['Content-Type'] = 'text/xml'
      request.body = request_body
    end

    response_body = HTMLEntities.new.decode response.body.force_encoding('ISO-8859-1')
    @response ||= Nokogiri::XML(response_body).remove_namespaces!
  end

  def request_body
    @request_body ||= <<~EOS
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
         <soapenv:Header/>
         <soapenv:Body>
            <tem:GetDadesHabitant>
               <tem:sConnexio></tem:sConnexio>
               <tem:DniDataNaix>#{unique_id}</tem:DniDataNaix>
            </tem:GetDadesHabitant>
         </soapenv:Body>
      </soapenv:Envelope>
    EOS
  end

  def check_age
    errors.add(:date_of_birth, I18n.t('census_authorization_handler.age_under_14')) unless age && age >= 14
  end

  def age
    return nil if date_of_birth.blank?

    now = Date.current
    extra_year = (now.month > date_of_birth.month) || (
      now.month == date_of_birth.month && now.day >= date_of_birth.day
    )

    now.year - date_of_birth.year - (extra_year ? 0 : 1)
  end
end
