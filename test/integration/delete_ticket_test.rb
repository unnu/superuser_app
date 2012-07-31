require 'test_helper'

class DeleteTicketTest < ActionDispatch::IntegrationTest

  setup do
    @ticket = Factory.create(:block_ticket)
    @ticket_div = "##{dom_id(@ticket)}"
  end

  context "admin" do
    setup do
      @admin = Factory.create(:user, :admin => true)
    end
  
    should "be able to delete ticket" do
      in_browser do
        sign_in(@admin)
        visit admin_user_path(@ticket.user)

        within '.admin-buttons' do
          handle_js_confirm do
            click_link I18n.t('admin.tickets.ticket.destroy')
          end
        end
        assert page.has_content?(I18n.t('admin.tickets.destroy.success'))
      end
    end
  end

  context "normal user" do
    should "not be able to delete ticket" do
      in_browser do
        sign_in(@ticket.user)
        visit user_path(@ticket.user)
        assert page.has_no_css?('.admin-buttons')
      end
    end
  end
end