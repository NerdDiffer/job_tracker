json.array!(@cover_letters) do |cover_letter|
  json.extract! cover_letter, :id, :posting_id, :job_application_id
  json.url cover_letter_url(cover_letter, format: :json)
end
