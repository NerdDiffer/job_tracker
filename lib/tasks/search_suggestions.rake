namespace :search_suggestions do

  desc 'Refresh search suggestions for company names'
  task :seed_company_names => :environment do |task, args|
    puts "Deleting existing keys for company names and refreshing..."
    SearchSuggestion.reseed_company_names
  end

  desc 'run all seed tasks for search suggestions'
  task :all => [:seed_company_names]
end
