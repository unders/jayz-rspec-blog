require 'spec_helper'

describe Comment do
  let(:comment) { Comment.make.save }

  describe "#post" do
    it "must be present" do
      Comment.make(post: nil).should have(1).error_on(:post)
    end
  end
end
