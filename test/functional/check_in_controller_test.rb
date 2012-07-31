require 'test_helper'

class CheckInControllerTest < ActionController::TestCase
  
  context "create" do
    
    setup do
      @ticket = Factory.create(:block_ticket)
      @user = @ticket.user
    end
    
    should "return status 200 if token correct and user has valid ticket" do
      get :create, :token => 'CVFEZFZM6A7KaJ', :nickname => @user.nickname
    
      assert_equal 200, response.status
    end
    
    should "return status 400 if token mismatch" do
      get :create, :token => 'no_valid_token', :nickname => @user.nickname
    
      assert_equal 400, response.status
    end
    
    should "return status 302 and redirect to me if user has no valid ticket" do
      @user = Factory(:user)
      get :create, :token => 'CVFEZFZM6A7KaJ', :nickname => @user.nickname
    
      assert_equal 302, response.status
      assert_redirected_to me_url
    end
    
    should "return status 302 and redirect to sign_up if ticket expired" do
      get :create, :token => 'CVFEZFZM6A7KaJ', :nickname => 'not_known_user', :email => 'foo@bar.de'
      
      assert_equal 302, response.status
      assert_redirected_to sign_up_url(nickname: 'not_known_user', email: 'foo@bar.de')
    end
  end
end
