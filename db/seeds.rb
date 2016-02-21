module Seed
  class << self
    # @param num [Integer], how many fake companies do you want to create?
    def companies_contacts_and_interactions(num)
      num.times do
        company = create_company
        contact = create_contact(company.id)
        create_interaction(contact.id)
      end
    end

    def user
      User.create!(first_name: 'Rafael', last_name: 'Espinoza',
                   email: 'rafael@example.com',
                   password: 'asdfasdf', password_confirmation: 'asdfasdf')
    end

    def job_applications_postings_and_cover_letters
      Company.all.each do |company|
        job_application = create_job_application(company.id)
        posting = create_posting(job_application.id)
        create_cover_letter(job_application.id, posting.posting_date)
      end
    end

    private

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
      JobApplication.create!(company_id: company_id, active: true, user_id: 1)
    end

    def create_posting(job_application_id)
      Posting.create!(job_application_id: job_application_id,
                      content: Faker::Lorem.paragraph,
                      posting_date: Faker::Date.backward(30),
                      source: Faker::Lorem.word,
                      job_title: Faker::Name.title)
    end

    def create_cover_letter(job_application_id, posting_date)
      CoverLetter.create!(job_application_id: job_application_id,
                          content: Faker::Lorem.paragraph,
                          sent_date: Faker::Date.between(posting_date, Date.today))
    end
  end
end

if Rails.env == 'development'
  # Feel free to comment out seeding methods you don't need.
  # By default, create 30 records for:
  #   Company, Contacts, Interaction, JobApplication, Posting, CoverLetter
  # Only 1 User is needed.
  num_to_seed = 30
  Seed.companies_contacts_and_interactions(num_to_seed)
  Seed.user
  Seed.job_applications_postings_and_cover_letters
end
