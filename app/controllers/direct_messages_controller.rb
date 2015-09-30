class DirectMessagesController < ApplicationController

  def sent
    @direct_messages = DirectMessage.where(["sender_id = ?", current_user])
  end

  def received
  	@direct_messages = DirectMessage.where(["recipient_id = ?", current_user])
  end

  def test
  	@direct_messages = DirectMessage.where(["sender_id = ? or recipient_id = ?",
  	                                         current_user, current_user])
  	@micropost = current_user.microposts.build if signed_in?
  end

  def index
    direct_message_user_ids = "SELECT sender_id FROM direct_messages
                     WHERE recipient_id = #{current_user.id} AND NOT sender_id = #{current_user.id}"
    @users = User.where("id IN (#{direct_message_user_ids})")
    @direct_messages = DirectMessage.where(["sender_id = ? or recipient_id = ?",
  	                                         current_user, current_user])
    @micropost = current_user.microposts.build if signed_in?
  end

  def show
    @user = User.find(params[:id])
    @direct_messages = DirectMessage.where(["sender_id = ? or recipient_id = ?",
  	                                         current_user, current_user])
    @micropost = current_user.microposts.build if signed_in?
  end
end