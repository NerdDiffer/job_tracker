module Seed
  @initial_users_count   = 5
  @initial_records_count = 30
  @default_password = 'password'
  @initial_sources = %w(Other LinkedIn Glassdoor StackOverflow GitHub Dice
    Indeed AngelList Craigslist Hired SimplyHired Beyond HackerNews)

  class << self
    # number of users (including yourself) to start out
    attr_accessor :initial_users_count
    # number of companies, contacts & notes to start out
    attr_accessor :initial_records_count
    attr_accessor :default_password
    attr_accessor :initial_sources

    def users
      User.create!(first_name: 'Rafael', last_name: 'Espinoza',
                   email: 'rafael@example.com',
                   password: default_password,
                   password_confirmation: default_password)

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

    private

    def create_user
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      email      = Faker::Internet.safe_email(first_name)
      password   = default_password
      password_confirmation = default_password
      User.create!(first_name: first_name, last_name: last_name,
                   email: email,
                   password: password,
                   password_confirmation: password_confirmation)
    end

    def create_company
      name = Faker::Company.name
      website = "www.#{name.parameterize}.com"
      category = Faker::Commerce.department
      Company.create!(name: name, website: website, category: category)
    end

    def create_source(name)
      Source.create!(name: name)
    end

    def create_contact(company_id, user_id)
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      phone_1 = Faker::PhoneNumber.phone_number
      phone_2 = Faker::PhoneNumber.phone_number
      email = Faker::Internet.safe_email(first_name)
      title = Faker::Name.title
      Contact.create!(company_id: company_id, user_id: user_id,
                      first_name: first_name, last_name: last_name,
                      phone_office: phone_1, phone_mobile: phone_2,
                      email: email, title: title)
    end

    def create_note(model, notable_id, user_id)
      Note.create!(content: Faker::Lorem.sentence,
                   notable_type: model, notable_id: notable_id,
                   user_id: user_id)
    end

    def create_job_application(company_id, user_id)
      JobApplication.create!(active: true,
                             company_id: company_id,
                             user_id: user_id)
    end

    def create_posting(job_application_id, source_id)
      Posting.create!(job_application_id: job_application_id,
                      content: Faker::Lorem.paragraph,
                      posting_date: Faker::Date.backward(30),
                      source_id: source_id,
                      job_title: Faker::Name.title)
    end

    def create_cover_letter(job_application_id, posting_date)
      content = Faker::Lorem.paragraph
      sent_date = Faker::Date.between(posting_date, Date.today)
      CoverLetter.create!(job_application_id: job_application_id,
                          content: content,
                          sent_date: sent_date)
    end

    def random_user_id
      @user_ids ||= User.all.map(&:id)
      @user_ids.sample
    end

    def random_company_id
      @company_ids ||= Company.all.map(&:id)
      @company_ids.sample
    end

    def random_source_id
      @source_ids ||= Source.all.map(&:id)
      @source_ids.sample
    end

    def random_contact_id(user_id = nil)
      if user_id.nil?
        @contact_ids ||= Contact.all.map(&:id)
        @contact_ids.sample
      else
        ids = Contact.belonging_to_user(user_id).map(&:id)
        ids.sample
      end
    end

    def random_job_application_id(user_id = nil)
      if user_id.nil?
        @job_application_ids ||= JobApplication.all.map(&:id)
        @job_application_ids.sample
      else
        ids = JobApplication.belonging_to_user(user_id).map(&:id)
        ids.sample
      end
    end

    def random_model
      [Contact, JobApplication].sample
    end

    def random_id(model, opts = {})
      model = model.to_s
      user_id = opts[:scope]

      case model
      when 'Contact'; then random_contact_id(user_id)
      when 'JobApplication'; random_job_application_id(user_id)
      else; fail 'pass in a valid model constant'
      end
    end
  end
end

if Rails.env == 'development'
  Seed.users
  Seed.companies
  Seed.sources
  Seed.job_applications_postings_and_cover_letters
  Seed.contacts
  Seed.notes
end
