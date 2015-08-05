module ApplicationHelper
  def interpolate_link url
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
      content_tag(:span, options[:true_text], :class => 'status true')
    else
      content_tag(:span, options[:false_text], :class => 'status false')
    end
  end

  def error_messages_for(object)
    render(:partial => 'shared/error_messages',
           :locals  => { :curr_object => object })
  end

  # Generate an HTML link for use in sorting for #index views
  # @param attribute [String], the name of the attribute to sort by
  # @param title [String], the name you want to display
  # @return [String], a generated HTML link
  def sortable(attribute, title = nil)
    attribute = attribute.to_s unless attribute.class == String
    title ||= attribute.titleize

    css_class = attribute == sort_column ? "current #{sort_direction}" : nil

    direction = (attribute == sort_column && sort_direction == 'asc') ?
      'desc' :
      'asc'

    link_to(title,
            params.merge(:sort => attribute, :direction => direction),
            {:class => css_class})
  end
end
