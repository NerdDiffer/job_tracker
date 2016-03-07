json.array!(@postings) do |posting|
  json.extract! posting, :id, :company_id, :job_application_id
  json.url posting_url(posting, format: :json)
end
