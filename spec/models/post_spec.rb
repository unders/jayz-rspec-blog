require 'spec_helper'

describe Post do
  let(:post) { Post.make.new }

  specify { post.should be_valid }
end
