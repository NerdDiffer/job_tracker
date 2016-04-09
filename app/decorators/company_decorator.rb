class CompanyDecorator < ApplicationDecorator
  delegate_all

  attr_reader :associated_company_id

  def show_recruitment_companies
    if agency?
      h.render('clients')
    else
      h.render('agencies')
    end
  end

  def companies_via_recruitments
    if agency?
      clients
    else
      agencies
    end
  end

  def link_to_remove(associated_company_id)
    @associated_company_id = associated_company_id
    recruitment = build_recruitment
    delete_path = h.company_recruitment_path(id, recruitment.id)
    h.link_to('Remove', delete_path, h.delete_link_opts)
  end

  private

  def clients
    opportunities_via_recruiting
      .where(agency_id: id)
      .map(&:client)
  end

  def agencies
    opportunities_via_recruiting
      .where(client_id: id)
      .map(&:agency)
  end

  def opportunities_via_recruiting
    h.current_user
     .opportunities_via_recruiting
  end

  def build_recruitment
    opportunities_via_recruiting
      .where(company_ids_match)
      .first
  end

  def company_ids_match
    if agency?
      { agency_id: id, client_id: associated_company_id }
    else
      { client_id: id, agency_id: associated_company_id }
    end
  end
end
