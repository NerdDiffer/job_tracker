module SearchSuggestion
  APP_PREFIX = 'job_tracker'.freeze
  DLMTR = ':'.freeze

  class << self
    attr_reader :company_names_key, :contact_names_key
  end

  # namespaced-parent keys
  @company_names_key = "#{APP_PREFIX}#{DLMTR}company_names"
  @contact_names_key = "#{APP_PREFIX}#{DLMTR}contact_names"

  # Refresh redis keys for Contact names.
  #   Deletes all existing redis keys for contact names.
  #   Then repopulates with the latest information.
  def self.refresh_contact_names
    delete_by(contact_names_key)
    seed(Contact, :name, contact_names_key)
  end

  # Refresh redis keys for Company names.
  #   Deletes all existing redis keys for company names.
  #   Then repopulates with the latest information.
  def self.refresh_company_names
    delete_by(company_names_key)
    seed(Company, :name, company_names_key)
  end

  # search for a term return the top x search results.
  # by default, will return the top 10 results.
  # @param query [String], the term to search for
  # @param options [Hash], options for your search
  def self.terms_for(query, options = {})
    min = options[:min] || 0
    max = options[:max] || 9
    parent_set = options[:parent_set] || company_names_key

    set_key_name = key_name(parent_set, query.downcase)
    $redis.zrevrange(set_key_name, min, max)
  end

  #
  # Private 'class' methods
  #

  # Populate a Redis sorted-set
  # @param model [Constant], the model name as a constant
  # @param attribute [String | Symbol], attribute on model
  # @param namespace_key [String], the key of the parent Redis sorted-set
  def self.seed(model, attribute, namespace_key)
    model.find_each do |record|
      val = record.public_send(attribute).to_s
      record_length = downcase_strip(val).length
      range = (1..record_length)

      generate_sets(range, namespace_key, val)
    end
  end

  def self.downcase_strip(val)
    val.downcase.strip
  end

  def self.generate_sets(range, namespace_key, val)
    range.each do |ind|
      set_key_name = key_name_for_generating_set(namespace_key, val, ind)
      score = 0
      member = val
      $redis.zadd(set_key_name, score, member)
    end
  end

  def self.key_name_for_generating_set(namespace_key, val, ind)
    processed_val = downcase_strip(val)
    prefix = processed_val[0...ind]
    key_name(namespace_key, prefix)
  end

  # Delete all Redis keys within a particular namespace. Useful for refreshing.
  # @param namespace_key [String], the namespaced-parent key you wish to delete
  def self.delete_by(namespace_key)
    glob = key_name(namespace_key, '*')
    keys = $redis.keys(glob)
    keys.each { |key| $redis.del(key) }
  end

  def self.key_name(parent_set_key, term)
    "#{parent_set_key}#{DLMTR}#{term}"
  end

  private_class_method :seed, :downcase_strip,
                       :generate_sets, :key_name_for_generating_set
  private_class_method :delete_by, :key_name
end
