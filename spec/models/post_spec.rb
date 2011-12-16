require 'spec_helper'

describe Post do
  let!(:post) { Post.make.save }
  let!(:other_post) { Post.make.new }

  specify { post.should be_valid }

  describe "#title" do
    it "must be present" do
      Post.make(title: nil).should have(1).error_on(:title)
      Post.make(title: "  ").should have(1).error_on(:title)
    end

    it "must be unique" do
      Post.make(title: post.title).should have(1).error_on(:title)
    end
  end
end
