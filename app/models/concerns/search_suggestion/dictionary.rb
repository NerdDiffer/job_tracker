module SearchSuggestion
  class Dictionary
    include Refresh

    APP_PREFIX = 'job_tracker'.freeze
    DLMTR = ':'.freeze

    attr_reader :key_base, :union_key, :model

    def initialize(base_key, model)
      @key_base  = name_of_key_base(base_key)
      @union_key = name_of_union_key(base_key)
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

    def name_of_key_base(base_key)
      "#{APP_PREFIX}#{DLMTR}#{base_key}"
    end

    def name_of_union_key(base_key)
      "#{APP_PREFIX}#{DLMTR}ALL#{DLMTR}#{base_key}"
    end
  end
end
