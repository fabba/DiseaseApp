class Country < ActiveRecord::Base
  has_many :user_logs
  has_many :reviews
  has_many :users, through: :reviews
  
  # Get the most relevant users for this country.
  # Returns an ordered list of users.
  # Relevance is determined by amount of likes on reviews for this country per user.
  def getRelevantUsers
    users = []
    userToRating = {}
    
    if !self.users.nil?
      self.users.each do |user|
        userToRating = userToRating.merge({user => 0})
      end
      
      self.reviews.each do |review| 
        userToRating[review.user] += review.review_logs.sum("rating")
      end
      
      users = Hash[userToRating.sort_by{|k, v| v}].keys().reverse() 
    end
    
	  return users
  end
  
end
