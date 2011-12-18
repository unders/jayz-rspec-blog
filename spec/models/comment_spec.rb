require 'spec_helper'

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

describe Comment do
  let(:comment) { Comment.make.save }

  describe "#post" do
    it "must be present" do
      Comment.make(post: nil).should have(1).error_on(:post)
    end
  end

  specify do
    Comment.make.newnew.should be_instance_of(Comment)
  end
end
