# call named scopes directly from URL params:
#   `@products = Product.filter(params.slice(:status, :location, :starts_with))`

module Filterable
  extend ActiveSupport::Concern

  # Call class method with same name as keys in `filtering_params`
  # with their associated values. Most useful for calling named scopes from
  # URL params. Make sure to whitelist params.
  module ClassMethods
    def filter filtering_params
      results = self.where(nil)
      filtering_params.each do |key, val|
        results = results.public_send(key, val) if val.present?
      end
      results
    end

    # Sort by an attribute, including virtual attributes.
    # Notable limitation: it returns an array. So it should be called last if
    # you are using planning to use it in a chain of scopes.
    # @param records, a list of records, usually an ActiveRecord_Relation,
    #   but could be an Array
    # @param attribute [String, Symbol], an attribute to sort by
    # @param direction [String], direction to sort by
    # @return [Array], returns a Ruby Array, not an ActiveRecord::Relation
    def sort_by_attribute(records, attribute, direction = 'asc')
      # Though sort_by is in the name, this method calls 'Array#sort'.
      # Other variations (such as sort!, sort_by, sort_by!) will not work.
      # Whereas '#sort' will work with an Array or ActiveRecord::Relation
      records.sort do |a, b|
        if direction == 'desc'
          b.public_send(attribute) <=> a.public_send(attribute)
        else
          a.public_send(attribute) <=> b.public_send(attribute)
        end
      end
    end

    # Return a record's attribute by searching for some other attribute first.
    # Can work with attributes on other models. Those attributes must be actual
    # database columns. This won't work on virtual attributes.
    # Will return the first match only.
    # TODO: Find a way to return several matches
    # @param search_attr [String, Symbol], the column name to search by
    #   (no virtual attributes)
    # @param value [String], the value to search for within the search_attribute
    # @param options [Hash], set of named parameter options
    # @return, the first matching record's id or nil
    def get_record_val_by(attribute, value, options = {})
      model       = options[:model] || self
      return_attr = options[:return_attr] || :id

      record = model.public_send("find_by_#{attribute.to_s}", value)
      record.read_attribute(return_attr) unless record.nil?
    end

  end
end
