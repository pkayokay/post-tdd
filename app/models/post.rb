class Post < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true
  validates :picture, presence: true
  validates :caption, presence: true
  mount_uploader :picture, PictureUploader
end