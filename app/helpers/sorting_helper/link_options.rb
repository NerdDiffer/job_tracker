module SortingHelper
  module LinkOptions
    def link_options!
      active! if active?
      category_names! if category_names?
      search! if search?
    end

    private

    def active?
      params[:active].present?
    end

    def active
      params[:active]
    end

    def active!
      @link_options[:active] = active
    end

    def category_names?
      params[:category_names].present?
    end

    def category_names
      params[:category_names]
    end

    def category_names!
      @link_options[:category_names] = category_names
    end

    def search?
      params[:search].present?
    end

    def search
      params[:search]
    end

    def search!
      @link_options[:search] = search
    end
  end
end
