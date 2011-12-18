

### Branch: step1
Set up a rails project

    $ rails new jayz-rspec-blog -d postgresql -T
    $ cd jayz-rspec-blog
    $ bundel exec rake db:create:all

### Branch: step2
Add the gems: jay_z and rspec-rails to the Gemfile.
  
    $ vi Gemfile
    group :development, :test do
      gem 'jay_z', :require => 'jay_z/rails'
      gem 'rspec-rails', "~> 2.7"
    end
    
Run these commands to set upp Rspec and JayZ with Rails

    $ bundle
    $ rails generate rspec:install
    $ rails generate jay_z:install



### Branch: step3
Configure Rspec and JayZ generators and generate a Post model.

    $ vi config/application.rb 
      config.generators do |g|
        g.test_framework :rspec, :fixture_replacement => :jay_z
      end
    
    $ rails generate model Post title:string body:text
    $ vi spec/blueprint.rb
    $ b rspec spec

    $ vi spec/models/post_spec.rb
    let(:post) { Post.make.new } 
    specify { post.should be_valid }
                                      
    $ b rake db:migrate db:test:prepare
    $ b rspec spec



### Branch: step4
Add validations to title.

    $ vi app/models/post.rb
    validates_presence_of :title
    validates_uniqueness_of :title
  
    let(:post) { Post.make.save }
    describe "#title" do
      it "must be present" do
        Post.make(title: nil).should have(1).error_on(:title)
        Post.make(title: "").should have(1).error_on(:title)
      end
  
      it "must be unique" do
        Post.make(title: post.title).should have(1).error_on(:title)
      end
    end


### Branch: step5
Change Post blueprint so that it generates unique titles

    $ vi spec/models/post_spec.rb
    let!(:post) { Post.make.save }
    let!(:other_post) { Post.make.new }

    $ vi spec/blueprint.rb  
    title { "My blog title #{sn}" }


  
### Branch step6
Spec has_many :comments in post model.

    $ rails generate model Comment commenter:string body:text post:references
    $ bundle exec rake db:migrate db:test:prepare

    $ vi spec/blueprint.rb
    class Post < Blueprint(ActiveRecord)
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

    $ vi spec/models/post_spec.rb
    let!(:post_with_comments) { Post.make(:with_2_comments).save.reload }
    describe "#comments" do
      it "returns all comments" do
        post_with_comments.comments.length.should == 2
      end
    end
  
### Branch: step7
Add validations to comment model.
  
    $ vi app/models/comment.rb
    validates_presence_of :post
    validates_presence_of :body
  
    $ vi spec/blueprint.rb
    define(:with_2_comments) do
      comments { [ Comment.make.new, Comment.make.new ] }
    end

    $ vi spec/models/post_spec.rb
    specify { post_with_comments.comments.length.should eq(2) }
 
    describe "#comments" do
      before do
       other_post.save!
       other_post.comments = [ Comment.make(post: nil, body: 'My body').new! ]
       post.comments << Comment.make(post: nil, body: 'This comment body').new!
      end
    
       it "return all comments" do
         Post.find(post.id).comments.map(&:body).should eq(['This comment body'])
         Post.find(other_post.id).comments.map(&:body).should eq(['My body'])
      end
    end

    $ vi spec/models/comment_spec.rb
    let(:comment) { Comment.make.save }

    describe "#post" do
      it "must be present" do
        Comment.make(post: nil).should have(1).error_on(:post)
      end
    end


### Branch: step8
Extend and change the jay_z behavior

    $ vi spec/bluprint.rb
    module JayZ
      module ActiveRecord
        def newnew
          @object
        end

        def save_and_reload
          save
          @object = @object.class.find(@object.id)
          @object
        end

        #def save
          # redefine the save method if you want a different behaviour.
        #end
      end

      module CustomRecord
        def my_method
          @object.my_method + " inside the CustomRecord proxy."
        end
      end

      class  MyCustomStuff < Blueprint(CustomRecord)
        default do
          my_method { "jihaa" }
        end
      end

      $ vi spec/models/blueprint.rb
      let(:post_with_comments) { Post.make(:with_2_comments).save_and_reload }

      $ vi spec/models/comment_spec.rb
      class MyCustomStuff
        extend JayZ
        attr_accessor :my_method
      end

      describe MyCustomStuff do
        specify do
          MyCustomStuff.make.new.my_method.should eq('jihaa')
          MyCustomStuff.make(my_method: 'new text').new.my_method.should eq('new text')
          MyCustomStuff.make(my_method: 'text').my_method.should
            eq('text inside the CustomRecord proxy.')
        end
      end

      specify do
        Comment.make.newnew.should be_instance_of(Comment)
      end
  
### Code

    $ vi lib/jay_z.rb

    module JayZ
      def self.Blueprint(jayz_module)
        Class.new(Blueprint) do
          include jayz_module
        end
      end

      def make(*args)
        JayZ.const_get(name).make(*args)
      end

      module ActiveRecord
        def new
          if @object.valid?
            @object
          else
            fail ::ActiveRecord::RecordInvalid.new(@object)
          end
        end

        def new!
          @object
        end
        
        def save
          @object.tap { |record| record.save! }
        end
      end
    end
