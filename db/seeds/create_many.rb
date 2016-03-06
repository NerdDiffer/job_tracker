module Seed
  class << self
    def users
      create_default_user
      other_user_count = initial_users_count - 1
      other_user_count.times { create_user }
    end

    def companies
      initial_records_count.times { create_company }
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
  end
end
