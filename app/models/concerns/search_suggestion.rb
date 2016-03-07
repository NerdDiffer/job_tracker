module SearchSuggestion
  class << self
    def refresh_category_names
      dictionary = SearchSuggestion::Dictionary.new('category_names', Category)
      dictionary.refresh
    end

    def refresh_company_names
      dictionary = SearchSuggestion::Dictionary.new('company_names', Company)
      dictionary.refresh
    end

    def terms_for(query, key)
      dictionary = select_dictionary(key)
      search = dictionary.search(query)
      search.results
    end

    private

    def select_dictionary(key)
      if key == 'category_names'
        model = Category
      else
        key = 'company_names'
        model = Company
      end
      SearchSuggestion::Dictionary.new(key, model)
    end
  end
end
