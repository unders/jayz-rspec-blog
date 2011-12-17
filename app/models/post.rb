class Post < ActiveRecord::Base
  has_many :comments

  validates_uniqueness_of :title
  validates_presence_of :title
end
