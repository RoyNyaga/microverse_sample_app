module SessionsHelper
	# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id # Places a temporary cookie on the user's browser containing the user's id which can be called using session[:user_id]
  end

  # Returns the current logged-in user (if any) else returns nill
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil? 
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
