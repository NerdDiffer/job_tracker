module SearchSuggestion
  class Dictionary
    include Refresh

    attr_reader :base_key, :union_key, :model

    def initialize(base_key, model)
      @base_key  = base_key
      @union_key = name_of_union_key
      @model = model
    end

    # Populate the sorted set (or refresh if it already exists).
    def refresh
      delete_union_set!
      delete_record_sets!
      populate_sets
      unionize_sets!
    end

    def search(query, max_results_count = 15)
      SearchSuggestion::Search.new(union_key, query, max_results_count)
    end

    private

    def name_of_union_key
      SearchSuggestion::KeyName.union(base_key)
    end
  end
end
