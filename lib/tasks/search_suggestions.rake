namespace :search_suggestions do
  desc 'Refresh search suggestions for company names'
  task refresh_company_names: :environment do
    puts 'Deleting existing keys for company names and refreshing...'
    SearchSuggestion.refresh_company_names
  end

  desc 'Refresh search suggestions for category names'
  task refresh_category_names: :environment do
    puts 'Deleting existing keys for category names and refreshing...'
    SearchSuggestion.refresh_category_names
  end

  desc 'run all seed tasks for search suggestions'
  task all: [:refresh_company_names, :refresh_category_names]
end
