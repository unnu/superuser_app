require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  should "have valid factories" do
    FactoryGirl.build(:ticket).valid?
    FactoryGirl.build(:time_ticket).valid?
    FactoryGirl.build(:block_ticket).valid?
  end

  context "for_checkin" do
    
    setup do
      @user = FactoryGirl.create(:user)
      @block_ticket = FactoryGirl.create(:block_ticket, checkins_left: 1, user: @user)
      @time_ticket = FactoryGirl.create(:time_ticket, user: @user)
    end

    should "have correct order for checkin" do
      assert_equal @time_ticket, @user.tickets.for_checkin[0]
      assert_equal @block_ticket, @user.tickets.for_checkin[1]
    end
  end
  
  context "BlockTicket" do
    
    setup do
      @ticket = FactoryGirl.build(:block_ticket, checkins_left: 12)
    end
    
    should "raise exception when trying to checkin with expired time" do
      @ticket = FactoryGirl.create(:block_ticket,
        start_time: Time.mktime(2011,11,01, 0,0,0),
        end_time:   Time.mktime(2011,11,01,11,0,0)
      )

      assert_raise Ticket::TicketExpiredError do
        @ticket.check_in!
      end
    end
    
    should "raise exception when trying to checkin with no checkins left" do
      @ticket = FactoryGirl.create(:expired_block_ticket)

      assert_raise Ticket::TicketExpiredError do
        @ticket.check_in!
      end
    end
    
    should "be able to check in 12 times" do
      12.times do
        assert ! @ticket.expired?
        @ticket.check_in!
        Timecop.freeze(Time.zone.now + 1.day)
      end
      assert @ticket.expired?
    end
    
    should "be able to check in the same day without losing a checkin" do
      2.times { @ticket.check_in! }
      assert_equal 11, @ticket.checkins_left
    end
  end

  context "TimeTicket" do

    setup do
      @ticket = FactoryGirl.create(:time_ticket)
    end

    should "raise exception when trying to checkin with expired ticket" do
      @ticket = FactoryGirl.create(:expired_time_ticket)
      
      assert_raise Ticket::TicketExpiredError do
        @ticket.check_in!
      end
    end

    should "be able to check in anytime while valid" do
      4.times do
        assert_nothing_raised do
          @ticket.check_in!
          @ticket.check_in!
        end
        Timecop.freeze(Time.zone.now + 1.week)
      end        
    end
  end
  
  context "recur!" do
    setup do
      @ticket = FactoryGirl.create(:recurring_block_ticket)
    end
    
    should "create a recure ticket if recurring true" do
      assert_difference "Ticket.count" do
        @ticket.recur!
      end
      
      new_ticket = @ticket.user.tickets.last
      
      %w(name user_id).each do |attribute|
        assert_equal @ticket.send(attribute), new_ticket.send(attribute)
      end
      
      assert_equal @ticket.end_time + 1.second, new_ticket.start_time
      assert_equal @ticket.id, new_ticket.recurring_ticket_id
    end
    
    should "raise NotRecurableError if recurring is false" do
      @ticket.update_attribute(:recurring, false)
      
      assert_no_difference "Ticket.count" do
        assert_raises Ticket::NotRecurableError do
          @ticket.recur!
        end
      end
    end
  end
  
  context "recurred?" do
    
    setup do
      @ticket = FactoryGirl.create(:recurring_block_ticket, recurring: true)
    end
    
    should "return true for recurred tickets" do
      @ticket.recur!
      assert @ticket.recurred?
    end
    
    should "return false for unrecurred tickets" do
      assert ! @ticket.recurred?
    end
  end
  
  context "scope recurring" do
    
    should "return expired and recurring tickets" do
      @expired_recurring_ticket = FactoryGirl.create(:recurring_block_ticket, end_time: 3.seconds.ago)
      @not_expired_recurring_ticket = FactoryGirl.create(:recurring_block_ticket, end_time: 1.minute.from_now)
      @not_recurring_ticket = FactoryGirl.create(:block_ticket)
      @recurred_ticket = FactoryGirl.create(:recurring_block_ticket)
      @recurring_ticket = @recurred_ticket.recur!
      
      assert_equal [@expired_recurring_ticket], Ticket.recurring
    end
  end
  
  context "recur_all!" do
    should "recur recurring tickets" do
      @expired_recurring_ticket = FactoryGirl.create(:recurring_block_ticket, end_time: 3.seconds.ago)
      
      assert ! @expired_recurring_ticket.recurred?
      
      assert_difference "Ticket.count" do
        Ticket.recur_all!
      end
      
      assert @expired_recurring_ticket.recurred?
    end
  end
end
