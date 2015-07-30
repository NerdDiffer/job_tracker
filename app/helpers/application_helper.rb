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

end
