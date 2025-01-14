module Roam
  class AdminApp
    module Views
      class Pages < Layout

        def pages
          @_pages.map do |page|
            {
              :page_updated => get_short_date(page.updated_at),
              :page_slug => page.slug,
              :page_title => page.title,
              :page_home => site.page_id == page.id
            }
          end
        end

      end
    end
  end
end
