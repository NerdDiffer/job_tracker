json.array!(@companies) do |company|
  json.extract! company, :id, :name, :website, :category
  json.url company_url(company, format: :json)
end
