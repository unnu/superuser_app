require 'test_helper'

class EditTicketTest < ActionDispatch::IntegrationTest

  setup do
    @ticket = Factory.create(:block_ticket)
    @ticket_div = "##{dom_id(@ticket)}"
  end

  context "admin" do
    setup do
      @admin = Factory.create(:user, :admin => true)
    end
  
    should "be able to edit ticket" do
      in_browser do
        sign_in(@admin)
        visit admin_user_path(@ticket.user)
        
        within @ticket_div do
          click_link I18n.t('admin.tickets.ticket.edit')
          select '2'
          click_link I18n.t('admin.tickets.ticket.update')
          
          within '.checkins_left' do
            assert page.has_content?('2')
          end
        end
      end
    end
  end

  context "normal user" do
    should "not be able to edit ticket" do
      in_browser do
        sign_in(@ticket.user)
        visit tickets_path
        
        assert page.has_css?(@ticket_div)
        within @ticket_div do
          assert page.has_no_content?(I18n.t('admin.tickets.ticket.edit'))
        end
      end
    end
  end
end