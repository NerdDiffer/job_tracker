require 'faker'

module Seed
  class << self
    private

    def create_default_user
      user = default_user.merge(password: default_password,
                                password_confirmation: default_password)
      User.create!(user)
    end

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
  end
end
