class CommentsController < ApplicationController

 def create
  @review = Review.find(params[:review_id])
  comment = Comment.where(user_id: @user.id, review_id: @review.id).take
  
  if comment.nil?
    @comment = @review.comments.create(user_id: @user.id, body: params[:comment][:body])
    if !@comment.save
      flash[:commentNotice] = @comment.errors.full_messages[0]
    end
    
  else
    flash[:commentNotice] = 'You already wrote a comment for this review'
  end
  
  redirect_to country_review_path(id: @review.id)
end

def edit  
  @comment = Comment.find(params[:id])
  
  # if current user did not write the comment, redirect to review.
  if @comment.user != @user
    redirect_to country_review_path(id: params[:review_id])
  else
    @country = Country.find(params[:country_id])
    @review = Review.find(params[:review_id])
  end
end

def update
  @comment = Comment.find(params[:id])
  
  if @comment.update(params[:comment].permit(:body))
    redirect_to country_review_path(id: params[:review_id])
  else
    render 'edit'
  end
end

def destroy
  @comment = Comment.find(params[:id])
  @comment.destroy
  redirect_to country_review_path(id: params[:review_id])
end

end
