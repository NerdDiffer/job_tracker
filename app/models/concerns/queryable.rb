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
      records.sort do |record_a, record_b|
        safe_compare(record_a, record_b, attribute, direction)
      end
    end

    # Return a record's attribute by searching for some other attribute first.
    # Works with attributes on other models. Also works w/ virtual attributes.
    #
    # Caveats:
    # - If searching by a virtual attribute, model must offer a corresponding
    #   class method in the naming pattern: '.find_by_*'.
    # - If that class method returns an ActiveRecord::Relation, then it may
    #   require further processing.
    # - Will return the first result only.
    # @param search_attr [String, Symbol], attribute to search by (virtual OK)
    # @param value [String], the attribute value to search for
    # @param return_attr [String, Symbol], name of attribute to return
    # @return, the first matching record's id or nil
    def get_record_val_by(attribute, value, return_attr = :id)
      result = public_send("find_by_#{attribute}", value)

      return nil if result.nil?

      # TODO: Find a way to handle several matches
      record = check_result(result)
      record.read_attribute(return_attr)
    end

    private

    def check_result(result)
      result.is_a?(ActiveRecord::Relation) ? result.first : result
    end

    def safe_compare(record_a, record_b, attribute, direction = 'asc')
      a = record_a.public_send(attribute)
      b = record_b.public_send(attribute)

      if any_nil?(a, b)
        handle_nil(a, b)
      else
        compare(a, b, direction)
      end
    end

    def any_nil?(a, b)
      a.nil? || b.nil?
    end

    def handle_nil(a, b)
      if a.nil? && b.nil?
        0
      elsif a.nil?
        1
      elsif b.nil?
        -1
      end
    end

    def compare(a, b, dir)
      if dir == 'desc'
        b <=> a
      else
        a <=> b
      end
    end
  end
end
