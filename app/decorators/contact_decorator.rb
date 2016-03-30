class ContactDecorator < ApplicationDecorator
  delegate_all

  def link_to_company
    h.link_to(company_name, company) if company_id?
  end

  def company_name
    company.name if company_id?
  end

  def phone_and_email
    h.render(partial: 'phone_and_email', locals: locals)
  end

  private

  def locals
    { contact: self }
  end
end
