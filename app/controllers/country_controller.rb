class CountryController < ApplicationController
  
  def change 
    countryName = params[:countryName]
    country = Country.where(name: countryName).take
    redirect_to country_path(:id => country.id)
  end
  
  def show

    @country = Country.where(id: params[:id]).take
    if @country
      @relevantDisease = Hash.new(0)
      @relevantUser = Hash.new(0)
      @relevantDiseases = Hash.new(0)
      @relevantUsers = Hash.new(0)
      @relevantTweets = []
      
      File.open("tweets/tweets.csv").each do |li|
	li = li.split('","')
	if li.length == 7
      	if li[6].include? @country.name

				@relevantDiseases[li[0]] += 1
				@relevantUsers[li[3]] += 1
				@relevantTweets += [[li[0],li[3],li[4]]]
			end
	
	end
	
        
      end
      if @relevantDiseases.keys.any?
      (0..10).each do |n| 
		disease = @relevantDiseases.max_by{|k,v| v}
		@relevantDiseases[disease[0]] = 0
		@relevantDisease[disease[0]] = disease[1]
		user = @relevantUsers.max_by{|k,v| v}
		@relevantUsers[user[0]] = 0
		@relevantUser[user[0]] = user[1]		
	end
	end
      @reviews = @country.reviews
    else
      redirect_to '/'
    end
  end
end
