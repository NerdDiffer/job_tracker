module ApplicationHelper
  def interpolate_link(url)
    "http://#{url}"
  end

  # Customize the output of a boolean field in a view.
  # By default, will make `true` = 'Yes', and `false` = 'No'.
  # @param boolean_val, the value whose output to customize
  # @param options, optional customizations
  def status_tag(boolean_val, options = {})
    options[:true_text]  ||= 'Yes'
    options[:false_text] ||= 'No'

    if boolean_val
      content_tag(:span, options[:true_text], class: 'status true')
    else
      content_tag(:span, options[:false_text], class: 'status false')
    end
  end

  def error_messages_for(object)
    locals = { curr_object: object }
    render(partial: 'shared/error_messages', locals: locals)
  end

  # Generate an HTML link for use in sorting for #index views
  # @param attribute [String], the name of the attribute to sort by
  # @param title [String], the name you want to display
  # @return [String], a generated HTML link
  def sortable(attribute, title = nil)
    attribute = attribute.to_s
    title ||= attribute.titleize

    attr_eql_to_sort_col = attribute == sort_column
    sort_asc = sort_direction == 'asc'

    direction = attr_eql_to_sort_col && sort_asc ? 'desc' : 'asc'
    params.merge!(sort: attribute, direction: direction)
    css_class = attr_eql_to_sort_col ? "current #{sort_direction}" : nil

    link_to(title, params, class: css_class)
  end

  def markdown(text)
    renderer_options = { with_toc_data: true }

    md_extensions = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(renderer_options)
    md = Redcarpet::Markdown.new(renderer, md_extensions)

    md.render(text).html_safe
  end
end
