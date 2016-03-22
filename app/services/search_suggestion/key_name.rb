module SearchSuggestion
  module KeyName
    APP_PREFIX = 'job_tracker'.freeze
    DLMTR = ':'.freeze

    class << self
      def base(key)
        "#{APP_PREFIX}#{DLMTR}#{key}"
      end

      def union(key)
        "#{APP_PREFIX}#{DLMTR}ALL#{DLMTR}#{key}"
      end

      def generic(key, term)
        "#{APP_PREFIX}#{DLMTR}#{key}#{DLMTR}#{term}"
      end
    end
  end
end
