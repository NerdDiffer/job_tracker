module Seed
  @initial_users_count   = 5
  @initial_records_count = 30
  @default_password = 'password'

  class << self
    # number of users (including yourself) to start out
    attr_accessor :initial_users_count
    # number of companies, contacts & interactions to start out
    attr_accessor :initial_records_count
    attr_accessor :default_password

    def users
      User.create!(first_name: 'Rafael', last_name: 'Espinoza',
                   email: 'rafael@example.com',
                   password: default_password,
                   password_confirmation: default_password)

      other_user_count = initial_users_count - 1
      other_user_count.times { create_user }
    end

    def companies_contacts_and_interactions
      initial_records_count.times do
        company = create_company
        contact = create_contact(company.id)
        create_interaction(contact.id)
      end
    end

    def job_applications_postings_and_cover_letters
      Company.all.each do |company|
        job_application = create_job_application(company.id)
        posting = create_posting(job_application.id)
        create_cover_letter(job_application.id, posting.posting_date)
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

    def create_contact(company_id)
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      phone1 = Faker::PhoneNumber.phone_number
      phone2 = Faker::PhoneNumber.phone_number
      email = Faker::Internet.safe_email(first_name)
      title = Faker::Name.title
      Contact.create!(first_name: first_name, last_name: last_name,
                      phone_office: phone1, phone_mobile: phone2,
                      email: email, title: title,
                      company_id: company_id)
    end

    def create_interaction(contact_id)
      Interaction.create!(contact_id: contact_id,
                          notes: Faker::Lorem.sentence,
                          approx_date: Faker::Date.backward(30),
                          medium: Faker::Number.between(0, 3).to_i)
    end

    def create_job_application(company_id)
      JobApplication.create!(company_id: company_id,
                             active: true,
                             user_id: random_user_id)
    end

    def create_posting(job_application_id)
      Posting.create!(job_application_id: job_application_id,
                      content: Faker::Lorem.paragraph,
                      posting_date: Faker::Date.backward(30),
                      source: Faker::Lorem.word,
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
  end
end

if Rails.env == 'development'
  Seed.users
  Seed.companies_contacts_and_interactions
  Seed.job_applications_postings_and_cover_letters
end
