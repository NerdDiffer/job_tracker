module Seed
  class << self
    def users
      default_account = new_default_account
      assign_and_save_users!(default_account, Users::Identity.new, User.new)

      other_user_count = (initial_users_count / 2) - 1
      assign_and_save_users_with_accounts(other_user_count)

      provider_id_user_count = initial_users_count / 2
      assign_and_save_users_with_provider_identities(provider_id_user_count)
    end

    def companies_categories_companies_categories
      initial_records_count.times { create_company }
      initial_categories.each { |name| create_category(name) }
      Company.all.each { |company| assign_companies_categories(company) }
    end

    def sources
      initial_sources.each { |name| create_source(name) }
    end

    def job_applications_postings_and_cover_letters
      initial_records_count.times do
        company_id = random_company_id
        user_id    = random_user_id
        source_id  = random_source_id

        job_application = create_job_application(company_id, user_id)
        posting = create_posting(job_application.id, source_id)
        create_cover_letter(job_application.id, posting.posting_date)
      end
    end

    def contacts
      initial_records_count.times do
        company_id = random_company_id
        user_id = random_user_id
        create_contact(company_id, user_id)
      end
    end

    def notes
      initial_records_count.times do
        user_id = random_user_id
        model = random_model
        notable_id = random_id(model, scope: user_id)
        create_note(model, notable_id, user_id)
      end
    end

    private

    def assign_and_save_users_with_accounts(n)
      n.times do
        account = new_account
        assign_and_save_users!(account, Users::Identity.new, User.new)
      end
    end

    def assign_and_save_users_with_provider_identities(n)
      n.times do |i|
        num = (i + 1) * 4
        uid = "uid_#{num}"
        provider_identity = new_provider_identity(uid)
        assign_and_save_users!(provider_identity, Users::Identity.new, User.new)
      end
    end
  end
end
