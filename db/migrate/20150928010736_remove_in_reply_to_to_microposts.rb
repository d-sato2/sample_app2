class RemoveInReplyToToMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :in_reply_to, :string
  end
end
