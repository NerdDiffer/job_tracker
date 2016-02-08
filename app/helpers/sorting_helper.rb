# Any controller that includes this module must define these methods:
#   model, collection, column_to_sort_by

module SortingHelper
  def sort_column
    sort = params[:sort]
    columns = model.column_names
    columns.include?(sort) ? sort : column_to_sort_by
  end

  def sort_direction
    dir = params[:direction]
    direction_allowed?(dir) ? dir : 'asc'
  end

  private

  def whitelisted?(attr = nil)
    attr = attr.to_sym unless attr.nil?
    whitelisted_attr.include?(attr)
  end

  def direction_allowed?(direction)
    %w(asc desc).include?(direction)
  end

  def custom_index_sort
    sort = params[:sort]
    dir  = params[:direction]
    model.sort_by_attribute(collection, sort, dir)
  end

  def model
    # noop, overridden by including class (ie: `Contact`)
  end

  def collection
    # noop, overridden by including class (ie: `@contacts`)
  end

  def column_to_sort_by
    # noop, overridden by including class (ie: 'name', 'sent_date', etc)
  end
end
