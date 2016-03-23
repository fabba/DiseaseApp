class ApplicationController < ActionController::Base
  before_filter :loadUser, :loadReceivedMessages
  
  def loadUser
    @user = User.where(id: session[:user]).take
  end

  def loadReceivedMessages
    @receivedMessages = []
    if !@user.nil?
      @user.received_messages.order(:updated_at).reverse.each do |recMsg|
        if !recMsg.viewed
          @receivedMessages += [recMsg] 
        end
      end
    end
  end
  
  protect_from_forgery with: :exception
  
end
