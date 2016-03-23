class MessagesController < ApplicationController

def show
  @message = Message.where(id: params[:id]).take
  
  if @user.nil? || @message.nil?
    redirect_to root_path
  elsif (@user != @message.receiver && @user != @message.sender)
    redirect_to user_messages_path(user_id: @user.id)
  else
    if @user == @message.receiver
      @message.update(viewed: true)
    end
    
    @reply = Message.new
    @receiver = @message.receiver
  end
end

def index
  if @user.nil?
    redirect_to root_path
  end
  
  @received_messages = @user.received_messages.order(:created_at).reverse
  @received_messages = @received_messages.paginate(:page => params[:recPage], :per_page => 10)
  
  @send_messages = @user.send_messages.order(:created_at).reverse
  @send_messages = @send_messages.paginate(:page => params[:sendPage], :per_page => 10)
end

def new
  @receiver = User.where("id = ?", params[:user_id]).take
   
  if @user.nil? || @receiver.nil?
    redirect_to root_path
  else
    @message = Message.new 
  end
end

def create
  title = params[:message][:title]
  body = params[:message][:body]
  receiverId = params[:user_id]
  senderId = @user.id

  @message = Message.new(sender_id: senderId, receiver_id: receiverId, title: title, body: body, viewed: false)
 
  if @message.save
    redirect_to user_message_path(user_id: senderId, id: @message.id)
  else
    @receiver = User.find(receiverId)
    render 'new'
  end
end

end
