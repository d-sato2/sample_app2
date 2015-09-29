class MicropostsController < ApplicationController

  require 'message_handler'
  include MessageHandler

  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :check_if_direct_message, only: :create
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

#    def process_direct_message
#      attr = params.require(:micropost).permit(:content)
#      @micropost = current_user.microposts.create(attr)
#      if @micropost.direct_message_format?
#        direct_message = DirectMessage.new(@micropost.to_direct_message_hash)
#        redirect_to root_path if direct_message.save
#      end
#    end
end