json.array!(@projects) do |project|
  json.extract! project, :id, :product_identifier, :localized_description, :localized_title, :price, :price_locale, :downloadable
  json.url project_url(project, format: :json)
end
