class Micropost < ActiveRecord::Base
  @@reply_to_regexp = /\A@([^\s]*)/
  belongs_to :user
  belongs_to :in_reply_to, class_name: "User"
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  before_save :extract_in_reply_to

  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  scope :from_users_followed_by_including_replies, lambda { |user| followed_by_including_replies(user) }

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def self.followed_by_including_replies(user)
    followed_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_ids}) AND in_reply_to_id IS NULL) OR user_id = :user_id OR in_reply_to_id = :user_id",
          user_id: user, user_name: user.user_name)
  end

  def extract_in_reply_to
    if match = @@reply_to_regexp.match(content)
       user = User.find_by(user_name: match[1])
      self.in_reply_to_id = user.id #if user
    end
  end
end