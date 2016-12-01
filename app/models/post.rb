class Post < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true
  validates :message, presence: true
  mount_uploader :picture, PictureUploader
end