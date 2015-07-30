json.array!(@interactions) do |interaction|
  json.extract! interaction, :id, :contact_id, :description, :approx_date
  json.url interaction_url(interaction, format: :json)
end
