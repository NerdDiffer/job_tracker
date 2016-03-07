path_to_seeds = Rails.root.join('db', 'seeds', '*.rb')
seed_files = Dir[path_to_seeds]
seed_files.each { |seed_file| require seed_file }

if Rails.env == 'development'
  Seed.users
  Seed.companies_categories_companies_categories
  Seed.sources
  Seed.job_applications_postings_and_cover_letters
  Seed.contacts
  Seed.notes
end
