class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :picture, presence: true
  validates :caption, presence: true
  mount_uploader :picture, PictureUploader
end