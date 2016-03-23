
class User < ActiveRecord::Base
  
  has_many :user_logs, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :review_logs, :dependent => :destroy
  
  has_many :received_messages, :class_name => "Message", :dependent => :destroy, :foreign_key => "receiver_id"
  has_many :send_messages, :class_name => "Message", :dependent => :destroy, :foreign_key => "sender_id"

  # Create user with encrypted password
  def self.userCreate(username,password)
    salt = BCrypt::Engine.generate_salt
    encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    user = User.create(:name => username, :password_hash => encrypted_password ,:password_salt => salt)
    return user
  end
  
  # checks if the inlog data is correct
  def self.authenticate(username, password)
    user = User.where(:name => username).take
    if user && match_password(username,password)
      return user
    else
      return false
    end
  end   
  
  # Checks if the given password is equal to the password in the database
  def self.match_password(username,password)
    user = User.where(:name => username).first
    if user.password_hash != BCrypt::Engine.hash_secret(password, user.password_salt)
      return false
    else 
      return true
    end
  end
  
  # Get all senders and receivers of messages to/from a particular user
  def getContacts
    messages = []  
    
    if !self.received_messages.nil?
      messagesRecv = (self.received_messages.order(:updated_at)).reverse 
	    messagesRecv.each do |recv|
	      user = User.find(recv.sender_id)
	      unless messages.include?(user)
		      messages += [user]
		    end
	    end
    end
    if !self.send_messages.nil?
      messagesSend = (self.send_messages.order(:updated_at)).reverse 
	    messagesSend.each do |send|
	      user = User.find(send.receiver_id)
	      unless messages.include?(user)
		      messages += [user]
		    end
	    end
    end
	  return messages
  end
  
  # Get all the reviews of a particular user
  def getSortedReviews
    reviews = []  
    
    if !self.reviews.nil?
      sortedReviews = (self.reviews.order(:updated_at)).reverse 
	    sortedReviews.each do |review|
		    reviews += [review]
	    end
    end
    
	  return reviews
  end
  
  # Get the countries the user has visited last updated first.	
	def getCountryVisited
    countries = []  
    logs = self.user_logs.where(visited: true)
    
    if !logs.nil?
      logs = (logs.order(:updated_at)).reverse 
	    logs.each do |log|
		    countries += [log.country]
	    end
    end
    
	  return countries
  end
  
  # Get the countries the user wishes to go last updated first.	
	def getCountryWish
    countries = []  
    logs = self.user_logs.where(wish: true)
    
    if !logs.nil?
      logs = (logs.order(:updated_at)).reverse 
	    logs.each do |log|
		    countries += [log.country]
	    end
    end
    
	  return countries
  end
  
  # Search for users with names similar to query.
  # Returns ordered list with exact matches to query first in list.
  def self.search(query)
    matches = User.where("name like ?", "%" + query + "%")
    exactMatches = matches.where(name: query)
    return exactMatches | matches
  end
  
  def visitCountry(countryId)
    updateLog(countryId, {:wish => false, :visited => true, :viewed => true})
  end

  def wishCountry(countryId)
    updateLog(countryId, {:wish => true, :visited => false, :viewed => true})
  end

  # Update the log belonging to user with countryId with the values in logTags (hash).
  #
  # Logtags may only have :wish, :viewed, :visited as keys.
  # false is returned if unsuccessful, true otherwise.
  def updateLog(countryId, logTags)
	
	  country = Country.where(:id => countryId).first
	  
	  testHash = {:wish => false, :visited => false, :viewed => false}.merge(logTags)
	  puts self
	  if !country.nil? || testHash.size != 3
			log = UserLog.where(:user_id => self.id, :country_id => countryId).first
	  	
			if log.nil?
			  logTags = {:user_id => self.id, :country_id => countryId}.merge(logTags)
			  logTags.reverse_merge!({:wish=> false, :visited => false, :viewed => false})
				log = UserLog.create(logTags)
			else
			  logTags = logTags.merge({:updated_at => Time.now})
				log.update(logTags)
			end
			return true
	  end
	return false
	end
end
