class UsersController < ApplicationController
  
  def show
    @userProfile = User.where(id: params[:id]).take
    
    if @userProfile
      @userProfile = User.find(params[:id])
      @countriesVisited = @userProfile.getCountryVisited
		  @countriesWish = @userProfile.getCountryWish
		  @reviews = @userProfile.getSortedReviews
		  @contactUsers = @userProfile.getContacts
	  else
	    redirect_to '/'
	  end
  end
  
  def logout
    reset_session
    @user = nil
    render '/users/logmenu' 
  end
  
  def register
    if params[:password] == params[:confirmpassword]
      if User.where(:name => params[:username]).take.nil?
        new_user = User.userCreate(params[:username], params[:password])
        session[:user] = new_user.id
        flash[:notice] = "Welcome, you succesfully register as #{new_user.name}"
      else
        flash[:notice] = "Username already exist"
        render '/users/registermenu' 
      end
    else
      flash[:notice] = "Passwords are not the same"
      render '/users/registermenu'
    end
  end
  
  def login
    authorized_user = User.authenticate(params[:username], params[:password])
    if authorized_user 
      flash[:notice] = "Welcome again, you logged in as #{authorized_user.name}"
      session[:user] = authorized_user.id
    else
      flash[:notice] = "Invalid Username or Password"
      render '/users/logmenu' 
    end
  end
  
  def create
    name = params[:nickName]
    password = params[:passWord]
    if User.where(:name => name).take.nil?
      user = User.create name: name, password: password
      session[:user] = user.id
    else
      @error = " Name already in use"
    end
  end
  
  # Show all countries and highlight those that are related to the current user
  def showCountries
    if session[:user].nil?
      puts "please log in"
      redirect_to "/"
    else
      @countriesVisited = @user.getCountryVisited
		  @countriesWish = @user.getCountryWish
    end
  end
  
  # search function of countries
  def zoomCountry
    @focus= Country.where('lower(name) like ?', "%" + params[:focus].downcase + "%")
  end
 
  #  The current user has visit the country
  def visitCountry
    countryId = params[:countryId]
    @user.visitCountry countryId
	  render :nothing => true
  end
  
  #  The current user wants to visit the country
  def wishCountry
    countryId = params[:countryId]	  
	  @user.wishCountry countryId
	  render :nothing => true
  end
  
  #search function of users
  def search
    @users = User.search(params[:query])
    @users = @users.paginate(:page => params[:page], :per_page => 30)
  end
end
