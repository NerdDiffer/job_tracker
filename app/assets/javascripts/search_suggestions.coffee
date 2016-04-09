jQuery ->
  company_names =
    dictionary: 'company_names',
    selectors: ['contact_company_name', 'job_application_company_name',
                'recruitment_client_name', 'recruitment_agency_name']
  category_names =
    dictionary: 'category_names',
    selectors: ['company_category_name']
  search_suggestions =
    base_path: '/search_suggestions',
    generate_selectors: (ids) ->
      css_id  = (selector) -> "##{selector}"
      selectors = ids.map (selector) -> css_id(selector)
      selectors.join(', ')
    generate_source: (dictionary_key) ->
      "#{this.base_path}?key=#{dictionary_key}"

  selectors_for_company_names = search_suggestions
                                  .generate_selectors(company_names.selectors)
  source_for_company_names    = search_suggestions
                                  .generate_source(company_names.dictionary)
  $(selectors_for_company_names).autocomplete
    source: source_for_company_names
  $('#company_category_name').autocomplete
    source: source_for_company_names
