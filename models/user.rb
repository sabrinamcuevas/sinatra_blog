class User
  include ActiveModel::Validations

  attr_accessor :id, :email, :address, :provider, :uid, :city, :state, :country, :phone, :document,
                :firstname, :lastname, :admin, :gender, :cuit, :role, :birthdate, :suspect_level, :alias,
                :display_currency, :allowed_to_log_in, :is_valid, :pwa_active, :mercado_pago_customer_id,
                :last_new_saw, :sign_up_date, :type_document, :street, :street_number, :street_floor,
                :street_floor_apartment, :department, :postal_code, :address_location,
                :confirmed_at, :banned_type, :user_referrer_id, :created_at, 
                :updated_at, :type, :all_documents_approved, :argentinian, :has_deposits, :user_coupons, :argentinian,
                :sesocio_user, :currency, :cash_amount, :card_company_id, :committed_amount, :photo

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) rescue next
    end
  end

  def self.find(id)
    return unless id.present?

    url = "#{ENV['BASE_URL_CORE']}/core/users/#{id}"
    json_response = Core.make_request(:get, url: url)
    user_attributes = json_response["data"]["attributes"].merge!({ "id" => json_response["data"]["id"] })

    User.new(user_attributes)
  end

  def self.find_by_email(email)
    url = "#{ENV['BASE_URL_CORE']}/core/users/find_by_email"
    data = { email: email }
    json_response = Core.make_request(:get, url: url, data: data)
    return nil if json_response.nil?
    user_attributes = json_response["data"]["attributes"].merge!({ "id" => json_response["data"]["id"] })
    User.new(user_attributes)
  end

end
