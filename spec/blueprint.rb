# endcoding: utf-8
module JayZ
  # Add your blueprints here.
  #
  # e.g.
  #    class User < Blueprint(ActiveRecord)
  #      default do
  #        name { "Anders" }
  #        admin { false }
  #      end
  #
  #      define(:admin) do
  #        admin { true }
  #      end
  #    end
  #
  #    class Post < Blueprint(ActiveRecord)
  #      default do
  #        title { "Post #{sn}" }
  #        body  { "Lorem ipsum...#" }
  #      end
  #    end

  class Post < Blueprint(ActiveRecord)
    default do
      title { "My blog title #{sn}" }
      body { "This is my body" }
    end

    define(:with_2_comments) do
      comments { [ Comment.make(:nil_post).new, Comment.make(:nil_post).new ] }
    end
  end


  class Comment < Blueprint(ActiveRecord)
    default do
      commenter { "anders@elabs.se" }
      body { "This is an important comment." }
      post { Post.make.new }
    end

    define(:nil_post) do
      post { nil }
    end
  end

end
