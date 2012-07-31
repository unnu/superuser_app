require 'test_helper'

class SearchUserAsAdminTest < ActionDispatch::IntegrationTest

  setup do
    @admin = Factory.create(:user, :admin => true)
    @user = Factory.create(:user, :first_name => "Norman", :last_name => "Timmler", :nickname => "unnu")
    @other_user = Factory.create(:user, :first_name => "Andre", :last_name => "Schweighofer", :nickname => "dre")
  end

  should "find matching user" do
    in_browser do
      sign_in(@admin)
      
      visit admin_users_path
      
      assert page.has_content?(@user.display_name)
      assert page.has_content?(@other_user.display_name)
      
      fill_in "search", :with => @user.first_name
      click_button "Search"

      assert page.has_content?(@user.display_name)
      assert page.has_no_content?(@other_user.display_name)
      
      fill_in "search", :with => @other_user.last_name
      click_button "Search"

      assert page.has_no_content?(@user.display_name)
      assert page.has_content?(@other_user.display_name)    
      
      fill_in "search", :with => @user.nickname
      click_button "Search"
      
      assert page.has_content?(@user.display_name)
      assert page.has_no_content?(@other_user.display_name)
    end
  end
end