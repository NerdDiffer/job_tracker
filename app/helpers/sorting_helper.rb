# Any controller that includes this module must define these methods:
#   model, collection, column_to_sort_by

module SortingHelper
  # Generate an HTML link for use in sorting #index views
  # @param attribute [String] the name of the attribute to sort by
  # @param title [String] the name you want to display
  # @return [String] a generated HTML link
  def generate_sortable_link(attribute, title = nil)
    direction = toggle_direction(attribute)
    css_class = css_class(attribute)

    title ||= attribute.titleize
    options = { sort: attribute, direction: direction }
    html_options = { class: css_class }

    # NOTE: previously, the 2nd argument was `params.merge....`, which was put
    # in at commit # 95ba8cc1 to work with the Filterable module. This broke
    # normal functionality, but made the 'active' toggle work with existing
    # sorts on other columns in the 'job_applications#index' view
    # TODO: make it work for:
    # - filtering with sorting
    # - regular sorts
    link_to(title, options, html_options)
  end

  def sort_column
    sorting_attr = params[:sort]
    col_sortable?(sorting_attr) ? sorting_attr : default_sorting_column
  end

  private

  def attr_eql_to_sort_col?(attr)
    attr == sort_column
  end

  def toggle_direction(attr)
    eql = attr_eql_to_sort_col?(attr)
    sort_asc = (params[:direction] == 'asc')
    (eql && sort_asc) ? 'desc' : 'asc'
  end

  def css_class(attr)
    eql = attr_eql_to_sort_col?(attr)
    eql ? "current #{sort_direction}" : 'foo'
  end

  def direction_allowed?(direction)
    %w(asc desc).include?(direction)
  end

  def sort_direction
    dir = params[:direction]
    direction_allowed?(dir) ? dir : 'asc'
  end

  def col_sortable?(column)
    columns = whitelisted_attr.map { |col| col.to_s }
    columns.include?(column)
  end

  def whitelisted?(attr = nil)
    attr = attr.to_sym unless attr.nil?
    whitelisted_attr.include?(attr)
  end

  def custom_index_sort
    sorting_attr = params[:sort]
    dir  = params[:direction]
    model.sort_by_attribute(collection, sorting_attr, dir)
  end

  def whitelisted_attr
    # noop, overridden by including class
  end

  def model
    # noop, overridden by including class (ie: `Contact`)
  end

  def collection
    # noop, overridden by including class (ie: `@contacts`)
  end

  def default_sorting_column
    # noop, overridden by including class (ie: 'name', 'sent_date', etc)
  end
end
