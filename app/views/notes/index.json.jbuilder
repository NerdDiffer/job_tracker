json.array!(@notes) do |note|
  json.extract! note, :id, :user_id, :notable_type, :notable_id, :contents, :created_at, :updated_at
  json.url note_url(note, format: :json)
end
