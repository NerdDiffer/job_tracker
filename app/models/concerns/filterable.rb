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

  end
end
