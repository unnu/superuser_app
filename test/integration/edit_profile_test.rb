require 'test_helper'
require 'capybara/rails'

class EditProfileTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup do
    @user = Factory.create(:user)
  end

  should "be able to edit profile without supplying password" do
    sign_in(@user)
    
    visit edit_user_path(@user)
    
    fill_in "user_email", :with => "not_#{@user.email}"
    click_button I18n.t('users.edit.submit_button')
    
    visit user_path(@user)
    
    assert page.has_content?("not_#{@user.email}")
  end

  should "be able to edit password" do
    sign_in(@user)
    visit edit_password_path(@user)
    new_password = "not_geheim"
  
    fill_in "user_password", :with => new_password
    fill_in "user_password_confirmation", :with => new_password
    click_button I18n.t('passwords.edit.submit_button')
  
    assert page.has_content?(I18n.t('passwords.edit.success'))
    
    click_link "Logout"
    sign_in(@user, :password => new_password)
  
    assert page.has_content?("Logout")
  end
end