require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new' # checks if the get signup_path displays the users/new page
    assert_select "div#error_explanation" #test for the presence of a div with id=erro_explanation on users/new html page
    assert_select 'div.alert' #test for the presece of a div with class alert on users/new html page
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? # function defined in the test_helper.rb file in test folder
  end



  # nothing realy important just testing fgit flow
end