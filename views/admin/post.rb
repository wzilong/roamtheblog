module Roam
  class AdminApp
    module Views
      class Post < Layout

        def new_post
          @post.new_record?
        end

        def active_post
          @post.active?
        end

        def page_action
          new_post ? "/admin/posts" : "/admin/posts/#{post_slug}"
        end

        def page_method
         new_post ? "post" : "put"
        end

        def page_header
          new_post ? "New Post" : post_title
        end

        def initialize
          create_getters_and_errors('post',%w{slug title body})
          create_error_getters('post',%w{author published_at tags})
        end

        def post_author
          @post.author ||= @current_user.name
        end

        def post_date
          get_short_date(@post.published_at)
        end

        def post_tags
          @post.tags.join(', ')
        end

        def post_location
          @post.location
        end

      end
    end
  end
end
