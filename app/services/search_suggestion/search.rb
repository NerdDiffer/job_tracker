module SearchSuggestion
  class Search
    attr_reader :set_key, :query, :max_results_count,
                :results, :range_len, :early_return_trigger,
                :start, :batch

    def initialize(set_key, query, max_results_count = 15)
      @set_key    = set_key
      @query      = query
      @results    = []
      @range_len  = 50 # limit to batches of 50
      @max_results_count    = max_results_count
      @early_return_trigger = :early

      search
    end

    private

    # Case sensitive search for a value in a sorted set.
    # @param query [String] your search term
    # @param max_results_count [Integer] maximum results to return
    # @return [Array] search results in lexigraphical order
    def search
      @start = starting_point
      return [] if start.nil?
      while continue_search?
        result = iterate
        break if early_trigger?(result)
      end
      results
    end

    def starting_point
      REDIS_CLIENT.zrank(set_key, query)
    end

    def continue_search?
      results.length <= max_results_count
    end

    def early_trigger?(result)
      result == early_return_trigger
    end

    def iterate
      next_batch
      return early_return_trigger if empty?(batch)

      batch.each do |entry|
        processed_entry = process(entry)
        break if early_trigger?(processed_entry)
      end
    end

    def next_batch
      stop   = start + range_len - 1
      @batch = REDIS_CLIENT.zrange(set_key, start, stop)
      @start += range_len
    end

    def empty?(batch)
      batch.empty?
    end

    def process(entry)
      range = prepare_range(entry)

      if not_matching?(entry, range)
        @max_results_count = results.length
        return early_return_trigger
      end

      append_to_results!(entry) if ok_to_append?(entry)
    end

    def prepare_range(entry)
      smaller_of_two = [entry.length, query.length].min
      (0...smaller_of_two)
    end

    def not_matching?(entry, range)
      entry[range] != query[range]
    end

    def ok_to_append?(entry)
      last_value_is_glob?(entry) && num_results_not_eq_to_max?
    end

    def last_value_is_glob?(entry)
      entry[-1..-1] == '*'
    end

    def num_results_not_eq_to_max?
      results.length != max_results_count
    end

    def append_to_results!(entry)
      name = entry[(0...-1)] # Take away the '*' from the entry
      @results << name
    end
  end
end
