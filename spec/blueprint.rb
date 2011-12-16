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
  end

end
