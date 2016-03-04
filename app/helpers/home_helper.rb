module HomeHelper
  def main_links
    [
      { name: 'Companies', path: companies_path },
      { name: 'Notes', path: notes_path },
      { name: 'Contacts', path: contacts_path },
      { name: 'Job Applications', path: job_applications_path },
      { name: 'Postings', path: postings_path },
      { name: 'Cover Letters', path: cover_letters_path }
    ]
  end
end
