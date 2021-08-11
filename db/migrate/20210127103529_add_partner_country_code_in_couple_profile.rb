class AddPartnerCountryCodeInCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :partner_country_code, :string
  end
end
