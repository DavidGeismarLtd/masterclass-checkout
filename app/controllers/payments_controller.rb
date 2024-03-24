class PaymentsController < ApplicationController
  require 'stripe'
  before_action :initialize_checkout_form, only: :create
  before_action :set_stripe
  helper_method :stripe_price_details, :stripe_product

  def new
    @checkout_form = CheckoutInformationsForm.new
  end

  def create
    if @checkout_form.valid?
      create_stripe_customer
      create_stripe_subscription
      return redirect_to_success_page
    else
      render :new
    end
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    render :new
  end

  def payment_informations
  end

  def thank_you
  end

  private

  def set_stripe
    Stripe.api_key = ENV['STRIPE_ENV'] == 'test' ? ENV['STRIPE_TEST_SECRET_KEY'] : ENV['STRIPE_LIVE_SECRET_KEY']
  end

  def stripe_product
    @stripe_product ||= Stripe::Product.retrieve(stripe_price_details.product)
  end

  def stripe_price_details
    @stripe_price_details ||= Stripe::Price.retrieve(stripe_price_id)
  end

  def stripe_price_id
    params[:stripe_price_id] || (ENV['STRIPE_ENV'] == 'test' ? ENV['STRIPE_TEST_DEFAULT_PRICE'] : ENV['STRIPE_LIVE_DEFAULT_PRICE'] ) 
  end
  
  def initialize_checkout_form
    @checkout_form = CheckoutInformationsForm.new(checkout_form_params)
  end

  def create_stripe_customer
    @customer = Stripe::Customer.create(
      email: @checkout_form.email,
      name: @checkout_form.full_name,
      phone: @checkout_form.phone,
      preferred_locales: ['fr'],
      address: {
        line1: @checkout_form.address,
        city: @checkout_form.city,
        postal_code: @checkout_form.postal_code,
        country: 'FR'
      },
      metadata: customer_metadata
    )
  end

  def customer_metadata
    {
      student_full_name: @checkout_form.student_full_name,
      student_address: @checkout_form.student_address,
      student_city: @checkout_form.student_city,
      student_postal_code: @checkout_form.student_postal_code,
    }
  end

  def create_stripe_subscription
    @subscription = Stripe::Subscription.create(
      customer: @customer.id,
      items: [{ price: @checkout_form.price_id }],
      payment_behavior: 'default_incomplete',
      payment_settings: { save_default_payment_method: 'on_subscription' },
      expand: ['latest_invoice.payment_intent']
    )
  end

  def redirect_to_success_page
    redirect_to payment_informations_path({
      subscriptionId: @subscription.id, 
      clientSecret: @subscription.latest_invoice.payment_intent.client_secret,
      stripePriceId: @checkout_form.price_id
    })
  end

  def checkout_form_params
    params.require(:checkout_informations_form).permit(:email, :phone, :full_name, :address, :city, :postal_code,
                  :student_full_name, :student_address, :student_city, :student_postal_code, :price_id)
  end
end