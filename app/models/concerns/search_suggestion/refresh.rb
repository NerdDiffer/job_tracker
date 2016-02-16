module SearchSuggestion
  module Refresh
    private

    def unionize_sets!
      REDIS_CLIENT.zunionstore(union_key, glob_keys)
    end

    def populate_sets(attribute = :name)
      model.find_each do |record|
        value = process_value(record, attribute)
        rec_key_name = key_name(value)

        process_record(rec_key_name, value)
      end
    end

    def process_value(record, attribute)
      value = record.public_send(attribute).to_s
      value.strip
    end

    def process_record(rec_key_name, value)
      length = value.length
      range = (1..length)
      process_members(rec_key_name, value, range)
    end

    def process_members(rec_key_name, value, range)
      range.each do |index|
        add_to_sorted_set!(rec_key_name, value, index)
      end
      append_with_glob_member!(rec_key_name, value)
    end

    def add_to_sorted_set!(rec_key_name, value, index_of_range)
      score = 0
      member = member_for_sorted_set(value, index_of_range)
      REDIS_CLIENT.zadd(rec_key_name, score, member)
    end

    # Also add the entire name with wildcard character, to sorted set
    # so that, 'marc', will also lead to 'marcella', 'marcelina', etc
    def append_with_glob_member!(rec_key_name, value)
      score = 0
      glob_member = value + '*'
      REDIS_CLIENT.zadd(rec_key_name, score, glob_member)
    end

    def member_for_sorted_set(value, index_of_range)
      value[0...index_of_range]
    end

    def delete_union_set!
      REDIS_CLIENT.del(union_key)
    end

    def delete_record_sets!
      keys = glob_keys
      keys.each { |key| REDIS_CLIENT.del(key) }
    end

    def key_name(term)
      delimiter = SearchSuggestion::Dictionary::DLMTR
      "#{key_base}#{delimiter}#{term}"
    end

    def glob_keys
      glob = key_name('*')
      REDIS_CLIENT.keys(glob)
    end
  end
end
