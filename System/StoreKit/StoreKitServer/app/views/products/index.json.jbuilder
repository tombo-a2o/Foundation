json.array!(@products) do |product|
  json.extract! product, :id, :product_identifier, :localized_description, :localized_title, :price, :price_locale, :downloadable
  json.url product_url(product, format: :json)
end
