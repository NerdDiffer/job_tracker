class JobApplicationDecorator < ApplicationDecorator
  delegate_all

  def add_or_view_attached_posting
    if posting?
      h.render('posting', locals: locals)
    else
      h.link_to('Add Posting', path_to_new_posting)
    end
  end

  def add_or_view_attached_cover_letter
    if cover_letter?
      h.render('cover_letter', locals: locals)
    else
      h.link_to('Add Cover Letter', path_to_new_cover_letter)
    end
  end

  def link_to_company
    if company_id?
      h.link_to(company_name, company)
    else
      h.content_tag(:span, no_company_message)
    end
  end

  private

  def posting?
    posting.present?
  end

  def cover_letter?
    cover_letter.present?
  end

  def locals
    { object: job_application }
  end

  def path_to_new_posting
    h.new_job_application_posting_path(job_application_id: id)
  end

  def path_to_new_cover_letter
    h.new_job_application_cover_letter_path(job_application_id: id)
  end

  def no_company_message
    'No company on this application'
  end
end
