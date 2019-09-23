module SessionsHelper
	# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id # Places a temporary cookie on the user's browser containing the user's id which can be called using session[:user_id]
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember 
    cookies.permanent.signed[:user_id] = user.id 
    cookies.permanent[:remember_token] = user.remember_token # remember_token here is the attr_accessor defined the user model
  end 

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any) else returns nill
  def current_user
    if (user_id = session[:user_id]) # If you were to read it in words, you wouldn’t say “If user id equals session of user id…”, but rather something like “If session of user id exists (while setting user id to session of user id)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil? 
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget # this forget method is an instance method defined in the user model
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default) # This evaluates to session[:forwarding_url] unless it’s nil,
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  
end
