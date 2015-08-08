namespace :search_suggestions do

  desc 'Refresh search suggestions for company names'
  task :refresh_company_names => :environment do |task, args|
    puts "Deleting existing keys for company names and refreshing..."
    SearchSuggestion.refresh_company_names
  end

  desc 'Refresh search suggestions for contact names'
  task :refresh_contact_names => :environment do |task, args|
    puts "Deleting existing keys for contact names and refreshing..."
    SearchSuggestion.refresh_contact_names
  end

  desc 'run all seed tasks for search suggestions'
  task :all => [:refresh_company_names, :refresh_contact_names]
end
