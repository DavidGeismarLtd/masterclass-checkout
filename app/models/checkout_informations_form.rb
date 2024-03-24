# app/models/checkout_form.rb
class CheckoutInformationsForm
  include ActiveModel::Model

  attr_accessor :email, :phone, :full_name, :address, :city, :postal_code,
                :student_full_name, :student_address, :student_city, :student_postal_code, :price_id

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :full_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :student_full_name, presence: true
  validates :student_address, presence: true
  validates :student_city, presence: true
  validates :student_postal_code, presence: true
  # Add any other validations you find necessary.
end