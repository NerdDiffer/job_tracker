module InteractionsHelper
  def generate_select_opts_for_media
    # To return a hash, you must group the 1st block parameter with parens.
    # Otherwise, it returns an array instead of a hash.
    media = Interaction.media
    media.each_with_object({}) do |(key), new_media|
      humanized_key = humanize(key)
      new_media[humanized_key] = key
      new_media
    end
  end

  private

  def humanize(key)
    key.humanize
  end
end
