class WelcomeController < ApplicationController
  #At the start page this function will rank each country on how popular it is
  def index
    countries = Country.all
    countriesScore = []
    
    countries.each do |country|
		  count = 0
		  File.open("tweets/tweets.csv").each do |li|
		  	li = li.split('","')
		 	if li.length == 7
      	          		if li[6].include? country.name

		  			count += 1
				end
			end
		  end
		  if count != 0
		    countriesScore += [[country,count]]
		  end
      end
      @countriesScore = countriesScore
  end
end
