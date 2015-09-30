class DirectMessage < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  default_scope -> { order('created_at DESC') }
  
  validates :content, presence: true
  validates :sender, presence: true
  validates :recipient, presence: true
end