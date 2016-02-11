module Queryable
  extend ActiveSupport::Concern

  module ClassMethods
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
        val_of_a = a.public_send(attribute).to_s
        val_of_b = b.public_send(attribute).to_s

        if val_of_a.nil? && val_of_b.nil?
          0
        elsif val_of_a.nil?
          1
        elsif val_of_b.nil?
          -1
        else
          if direction == 'desc'
            val_of_b <=> val_of_a
          else
            val_of_a <=> val_of_b
          end
        end
      end
    end

    # Return a record's attribute by searching for some other attribute first.
    # Works with attributes on other models. Also works w/ virtual attributes.
    # If searching by a virtual attribute, model must offer a corresponding
    # class method in the naming pattern: '.find_by_*'.
    # If that class method returns an ActiveRecord::Relation, then it may
    # require further processing.
    # Will return the first match only.
    # TODO: Find a way to return several matches
    # @param search_attr [String, Symbol], attribute to search by (virtual OK)
    # @param value [String], value to search for within search_attribute
    # @param options [Hash], set of named parameter options
    # @return, the first matching record's id or nil
    def get_record_val_by(attribute, value, options = {})
      model       = options[:model] || self
      return_attr = options[:return_attr] || :id
      record = model.public_send("find_by_#{attribute}", value)

      unless record.nil?
        class_of_relation = check_relation_class(record)
        class_of_relation.read_attribute(return_attr)
      end
    end

    # If something descends from ActiveRecord::Relation, return first in list
    # Otherwise, return the object
    def check_relation_class(object_or_relation)
      ancestors   = object_or_relation.class.ancestors
      ar_included = ancestors.include?(ActiveRecord::Relation)
      ar_included ? object_or_relation.first : object_or_relation
    end
  end
end
