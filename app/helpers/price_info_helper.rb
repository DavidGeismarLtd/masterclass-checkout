# app/helpers/form_helper.rb
module PriceInfoHelper
  def price_info_helper(stripe_price=nil)

  end

  def interval(label)
    case label
    when 'month'
      'mois'
    when 'year'
      'an'
    end
  end

  def price_in_euros(price_in_cents)
    price_in_euros / 100
  end

  def price_currency
    €
  end
end