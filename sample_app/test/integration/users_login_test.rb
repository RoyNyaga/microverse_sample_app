require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
    	@user = users(:roy) # represent the users created in the fixtures file
  	end

  test "login with invalid information" do
    get login_path #step 1: Visit the login path
    assert_template 'sessions/new'# step 2: verify that the new sessions form renders properly
    post login_path, params: { session: { email: "", password: "" } } #setp 3: post to the sessions path with an invalid params hash
    assert_template 'sessions/new' # step 4: Verify that the new sessions form gets re-rendered at a failed submission
    assert_not flash.empty? #step 5: verify that there is a flash error message
    get root_path #step 6: Visit another page, this time arround the home url
    assert flash.empty? #step 7: verify that the flash message doesn't appera on the new page.
  end

 # To understand this test the more, check inside the fixtures file
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'roy12345' } }
    assert is_logged_in?
    assert_redirected_to @user # check the right redirect target. chapter 8
    follow_redirect! # actually visit the target page. chapter 8
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 #verifies that the login link disappears 
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

end
