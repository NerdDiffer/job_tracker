class ContactDecorator < ApplicationDecorator
  delegate_all

  def link_to_company
    h.link_to(company_name, company) if company?
  end

  def company_name
    company.name if company?
  end

  private

  def company?
    company.present?
  end
end
