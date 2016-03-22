module SearchSuggestion
  module Refresh
    module Model
      private

      def delete_redis_keys!
        if same_count?
          zremrangebylex
        else
          remove_model_keys_only
        end

        REDIS_CLIENT.del(model_key)
      end

      def names_key
        SearchSuggestion::KeyName.base(names_base_key)
      end

      def all_names_keys
        SearchSuggestion::KeyName.union(names_base_key)
      end

      def model_key
        SearchSuggestion::KeyName.generic(names_base_key, name)
      end

      def lex_min
        "[#{name[0]}"
      end

      def lex_max
        "[#{name}*"
      end

      def zlexcount(keyspace, min, max)
        range = REDIS_CLIENT.zrangebylex(keyspace, min, max)
        range.length
      end

      def lex_count_model
        zlexcount(model_key, '-', '+')
      end

      def lex_count_all
        zlexcount(all_names_keys, lex_min, lex_max)
      end

      def same_count?
        lex_count_model == lex_count_all
      end

      def lex_range
        REDIS_CLIENT.zrangebylex(all_names_keys, lex_min, lex_max)
      end

      def zremrangebylex
        lex_range.each do |key|
          REDIS_CLIENT.zrem(all_names_keys, key)
        end
      end

      def remove_model_keys_only
        names_with_same_initial = prepare_other_set_names

        lex_range.each do |member|
          remove_unless_member_of_another(names_with_same_initial, member)
        end
      end

      def remove_unless_member_of_another(names_with_same_initial, member)
        member_of_another = member_of_another?(names_with_same_initial, member)
        REDIS_CLIENT.zrem(all_names_keys, member) unless member_of_another
      end

      def prepare_other_set_names
        names = select_globbed_members
        # chop off the last character ('*')
        names = names.map(&:chop)
        # Remove the current model_key from this array
        names.reject { |m| m == name }
      end

      # get members with '*' at the end
      def select_globbed_members
        lex_range.select { |member| last_char_glob?(member) }
      end

      def last_char_glob?(member)
        member[(-1..-1)] == '*'
      end

      def member_of_another?(list, val)
        list.any? do |name_of_other|
          set_key = "#{names_key}:#{name_of_other}"
          REDIS_CLIENT.zrank(set_key, val)
        end
      end
    end
  end
end
