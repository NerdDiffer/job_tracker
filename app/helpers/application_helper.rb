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
