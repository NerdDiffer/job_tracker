# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# @param num [Integer], how many fake companies do you want to create?
def seed_companies_contacts_and_interactions(num)
  num.times do
    # create companies
    name = Faker::Company.name
    website = "www.#{name.parameterize}.com"
    category = Faker::Commerce.department
    company = Company.create!(name: name,
                              website: website,
                              category: category)

    # create contacts
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    phone1 = Faker::PhoneNumber.phone_number
    phone2 = Faker::PhoneNumber.phone_number
    email = Faker::Internet.safe_email(first_name)
    title = Faker::Name.title
    contact = Contact.create!(first_name: first_name, last_name: last_name,
                              phone_office: phone1, phone_mobile: phone2,
                              email: email, title: title,
                              company_id: company.id)

    # create interactions
    Interaction.create!(contact_id: contact.id,
                        notes: Faker::Lorem.sentence,
                        approx_date: Faker::Date.backward(30),
                        medium: Faker::Number.between(0, 3).to_i)
  end
end

def seed_user
  User.create!(first_name: 'Rafael', last_name: 'Espinoza',
               email: 'rafael@example.com',
               password: 'asdfasdf', password_confirmation: 'asdfasdf')
end

def seed_job_applications_postings_and_cover_letters
  Company.all.each do |company|
    # create job applications
    ja = JobApplication.create!(company_id: company.id,
                                active: true,
                                user_id: 1)

    # create postings
    p = Posting.create!(job_application_id: ja.id,
                    content: Faker::Lorem.paragraph,
                    posting_date: Faker::Date.backward(30),
                    source: Faker::Lorem.word,
                    job_title: Faker::Name.title)

    # create cover letters
    pd = p.posting_date
    CoverLetter.create!(job_application_id: ja.id,
                        content: Faker::Lorem.paragraph,
                        sent_date: Faker::Date.between(pd, Date.today))
  end
end

# Do not let this run in production. Make it available for testing.
unless Rails.env == 'production'
  # Feel free to comment out seeding methods you don't need.
  # By default, create 30 records for:
  #   Company, Contacts, Interaction, JobApplication, Posting, CoverLetter
  # Only 1 User is needed.
  num_to_seed = 30
  seed_companies_contacts_and_interactions(num_to_seed)
  seed_user
  seed_job_applications_postings_and_cover_letters
end
