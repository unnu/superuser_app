require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should "have a valid factory" do
    FactoryGirl.build(:user).valid?
  end
  
  context "validations" do
    setup do 
      @user = FactoryGirl.create(:user)
    end
    
    should "have an unique nickname" do
      assert_raise ActiveRecord::RecordInvalid do
       FactoryGirl.create(:user, :nickname => @user.nickname)
      end
    end
    
    should "always have a name" do
      assert_raise ActiveRecord::RecordInvalid do
       FactoryGirl.create(:user, :first_name => "")
      end
    end
  end
end
