class NoteDecorator < ApplicationDecorator
  delegate_all

  def link_destination
    if contact_type?
      contact_path
    elsif job_application_type?
      job_application_path
    end
  end

  def notable_name
    if contact_type?
      notable.name
    elsif job_application_type?
      notable.title
    end
  end

  private

  def contact_type?
    notable_type.to_s == 'Contact'
  end

  def job_application_type?
    notable_type.to_s == 'JobApplication'
  end

  def contact_path
    h.contact_path(notable_id)
  end

  def job_application_path
    h.job_application_path(notable_id)
  end
end
