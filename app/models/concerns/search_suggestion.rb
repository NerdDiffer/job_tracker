class SearchSuggestion

  APP_PREFIX = "job_tracker"
  DLMTR  = ":"

  # namespaced-parent keys
  @company_names_key = "#{APP_PREFIX}#{DLMTR}company_names"

  # class methods

  def self.seed_company_names
    seed(Company, :name, @company_names_key)
  end

  # search for a term return the top x search results
  def self.terms_for(query, options = {})
    options[:min] ||= 0 # zero-indexed results
    options[:max] ||= 9 # zero-indexed results
    options[:parent_set] ||= @company_names_key

    set_key_name = make_sub_set_key(options[:parent_set], query.downcase)
    $redis.zrevrange(set_key_name, options[:min], options[:max])
  end

  # @param model [Constant], the model name as a constant
  # @param attribute [String | Symbol], attribute on model
  # @param namespace_key [String], the key of the parent Redis sorted-set
  def self.seed(model, attribute, namespace_key)
    model.find_each do |record|
      record_val = record.read_attribute(attribute).to_s.downcase.strip

      ( 1..(record_val.length) ).each do |ind|
        prefix = record_val[0...ind]
        set_key_name = make_sub_set_key(namespace_key, prefix)
        $redis.zadd(set_key_name, 0, record_val)
      end
    end

  end

  def self.make_sub_set_key(key_of_parent_set, term)
    "#{key_of_parent_set}#{DLMTR}#{term}"
  end

end
