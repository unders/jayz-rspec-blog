require 'spec_helper'

describe Post do
  let!(:post) { Post.make.save }
  let!(:other_post) { Post.make.new }
  let(:post_with_comments) { Post.make(:with_2_comments).save.reload }

  specify { post.should be_valid }
  specify { post_with_comments.comments.length.should eq(2) }

  describe "#title" do
    it "must be present" do
      Post.make(title: nil).should have(1).error_on(:title)
      Post.make(title: "  ").should have(1).error_on(:title)
    end

    it "must be unique" do
      Post.make(title: post.title).should have(1).error_on(:title)
    end
  end

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
end
