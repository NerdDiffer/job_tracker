module ApplicationHelper
  def interpolate_link(url)
    "http://#{url}"
  end

  # Customize the output of a boolean field in a view.
  # By default, will make `true` = 'Yes', and `false` = 'No'.
  # @param boolean_val, the value whose output to customize
  # @param options, optional customizations
  def status_tag(boolean_val, options = {})
    if boolean_val
      content = options[:true_text] || 'Yes'
      additional_options = { class: 'status true' }
    else
      content = options[:false_text] || 'No'
      additional_options = { class: 'status false' }
    end
    content_tag(:span, content, additional_options)
  end

  def error_messages_for(object)
    locals = { curr_object: object }
    render(partial: error_messages_partial, locals: locals)
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(renderer_options)
    md = Redcarpet::Markdown.new(renderer, md_extensions)
    html_safe(md.render(text))
  end

  def delete_link_opts
    {
      method: :delete,
      data: { confirm: 'Are you sure?' }
    }
  end

  private

  def error_messages_partial
    'shared/error_messages'
  end

  def renderer_options
    { with_toc_data: true }
  end

  def md_extensions
    {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true
    }
  end

  def html_safe(input)
    input.html_safe
  end
end
