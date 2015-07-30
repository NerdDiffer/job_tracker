json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :title, :company_id, :phone1, :phone2, :email
  json.url contact_url(contact, format: :json)
end
