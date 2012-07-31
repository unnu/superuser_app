require 'test_helper'

class DeleteUserTest < ActionDispatch::IntegrationTest

  setup do
    @ticket = Factory.create(:block_ticket)
    @user = @ticket.user
  end

  context "admin" do
    setup do
      @admin = Factory.create(:user, :admin => true)
    end
  
    should "be able to delete a user" do
      in_browser do
        sign_in(@admin)
      
        visit admin_user_path(@user)
        
        click_button 'delete-user'
        assert_equal admin_users_path, current_path
      
        visit admin_user_path(@user)
        assert_equal 404, page.status_code
      end
    end
  end
end