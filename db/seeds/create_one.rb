require 'faker'

module Seed
  class << self
    private

    def create_default_account
      account = default_account.merge(password: default_password,
                                      password_confirmation: default_password)
      Users::Account.create!(account)
    end

    def create_account
      name = Faker::Name.name
      email      = Faker::Internet.safe_email(name)
      password   = default_password
      password_confirmation = default_password
      Users::Account.create!(name: name,
                             email: email,
                             password: password,
                             password_confirmation: password_confirmation)
    end

    def create_omni_auth_user(uid)
      Users::OmniAuthUser.create!(provider: default_provider, uid: uid)
    end

    def create_company
      name = Faker::Company.name
      website = "www.#{name.parameterize}.com"
      Company.create!(name: name, website: website)
    end

    def create_category(name)
      Category.create!(name: name)
    end

    def already_assigned?(company, category_id)
      company.categories.exists?(id: category_id)
    end

    def assign_companies_categories(company)
      n = (1..2).to_a.sample
      n.times do
        category_id = random_category_id

        unless already_assigned?(company, category_id)
          category = Category.find(category_id)
          company.categories << category
        end
      end
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
      posting_params = {
        job_application_id: job_application_id,
        content: Faker::Lorem.paragraph,
        posting_date: Faker::Date.backward(30),
        source_id: source_id,
        job_title: Faker::Name.title
      }
      JobApplications::Posting.create!(posting_params)
    end

    def create_cover_letter(job_application_id, date)
      content = Faker::Lorem.paragraph
      sent_date = Faker::Date.between(date, Date.today)
      cover_letter_params = {
        job_application_id: job_application_id,
        content: content,
        sent_date: sent_date
      }
      JobApplications::CoverLetter.create!(cover_letter_params)
    end
  end
end
