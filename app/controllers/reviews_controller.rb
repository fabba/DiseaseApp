class ReviewsController < ApplicationController

def index
  @country = Country.where("id = ?", params[:country_id]).take
  @reviews = @country.reviews.paginate(:page => params[:page], :per_page => 20)
end

def show
  @review = Review.where(id: params[:id]).take
  
  if @review 
    @author = @review.user
    @country = Country.find(params[:country_id])
    
    if !@user.nil?
      reviewLog = @user.review_logs.where(review_id: params[:id]).take
      if reviewLog
        reviewLog.update(seen: true)
      else
        ReviewLog.create review_id: @review.id, user_id: @user.id, seen: true, rating: 0
      end
    end
  else
    redirect_to '/'
  end
end

def edit
  @review = Review.where("id = ?", params[:id]).take
  if !@review.nil? && @review.user == @user
    @country = Country.find(params[:country_id])
  else
    redirect_to root_path
  end
end

def update
  @review = Review.find(params[:id])

  if @review.update(params[:review].permit(:title, :body))
    redirect_to country_review_path(id: @review.id)
  else
    @country = Country.find(params[:country_id])
    render 'edit'
  end
end

def new  
  if @user.nil?
    redirect_to country_path(id: params[:country_id])
  else
    @country = Country.find(params[:country_id])
    review = Review.where(user_id: @user.id, country_id: @country.id).take
    
    if review.nil?
      @review = Review.new
    else
      flash[:notice] = 'You already wrote a review for this country.'
      redirect_to country_review_path(id: review.id)
    end
  end
end
 
def create
  title = params[:review][:title]
  body = params[:review][:body]
  countryId = params[:country_id]
  userId = @user.id
  review = Review.where(user_id: userId, country_id: countryId).take
  
  if !review.nil?
    flash[:notice] = 'You already wrote a review for this country.'
    redirect_to country_review_path(id: review.id)
    
  else
    @review = Review.new(user_id: userId, title: title, body: body, country_id: countryId)
   
    if @review.save
      redirect_to country_review_path(id:@review.id)
    else
      @country = Country.find(countryId)
      render 'new'
    end
  end
end

def destroy
  @review = Review.find(params[:id])
  @review.destroy
  redirect_to country_path(id: params[:country_id])
end

def like
  if !@user.nil?
    reviewLog = @user.review_logs.where(review_id: params[:id]).take
    if reviewLog
      reviewLog.update(rating: params[:like])
    end
    redirect_to country_review_path(country_id: params[:country_id], id: params[:id])
  else
    redirect_to '/'
  end
end

end
