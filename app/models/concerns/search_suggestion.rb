module SearchSuggestion
  class << self
    def refresh_contact_names
      base_key = 'contact_names'
      dictionary = SearchSuggestion::Dictionary.new(base_key, Contact)
      dictionary.refresh
    end

    def refresh_company_names
      base_key = 'company_names'
      dictionary = SearchSuggestion::Dictionary.new(base_key, Company)
      dictionary.refresh
    end

    def terms_for(query, options = {})
      base_key = options[:base_key]
      dictionary = select_dictionary(base_key)
      search = dictionary.search(query)
      search.results
    end

    private

    def select_dictionary(base_key)
      if base_key == 'contact_names'
        model = Contact
      else
        base_key = 'company_names'
        model = Company
      end
      SearchSuggestion::Dictionary.new(base_key, model)
    end
  end
end
