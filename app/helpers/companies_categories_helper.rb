module CompaniesCategoriesHelper
  def display_names(names, opts = {})
    delimiter = delimiter(opts)
    join_list(names, delimiter)
  end

  def generate_select_opts_for_category_names
    all_categories = fetch_all_categories
    all_categories.map(&:display_name)
  end

  private

  def delimiter(opts = {})
    opts[:delimiter] || ', '
  end

  def join_list(arr, delimiter)
    arr.join(delimiter)
  end

  def fetch_all_categories
    @categories ||= Category.all
  end
end
