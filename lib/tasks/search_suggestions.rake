namespace :search_suggestions do

  desc 'refresh search suggestions for company names'
  task :seed_company_names => :environment do |task, args|
    puts "Refreshing company names..."
    SearchSuggestion.seed_company_names
  end

  desc 'run all seed tasks for search suggestions'
  task :all => [:seed_company_names]
end
