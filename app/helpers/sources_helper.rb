module SourcesHelper
  def generate_select_opts_for_source_names
    all_sources = fetch_all_sources

    all_sources.each_with_object({}) do |(source), sources|
      collect(source, sources)
    end
  end

  private

  # TODO: Find a better way to query & cache this information
  def fetch_all_sources
    @sources ||= Source.all
  end

  def collect(source, sources)
    name = source.display_name
    id   = source.id
    sources[name] = id
    sources
  end
end
