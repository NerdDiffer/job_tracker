module InteractionsHelper
  def generate_select_opts_for_media
    # To return a hash, you must group the 2nd parameter of this block
    # with parentheses. Otherwise, it returns an array instead of a hash.
    # The val is not needed at the moment.
    # Writing the block parameters as `|new_media, key|` will return an array.
    # This could also work, if you assign `key` as the value to
    # `key[0].humanize`. But this is unintuitive to me.
    Interaction.media.each_with_object({}) do |(key), new_media|
      new_media[key.humanize] = key
      new_media
    end
  end
end
