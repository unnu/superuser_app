module ApplicationHelper

  def ticket_destroy_link(ticket, text)
    link_to(
      text, 
      admin_user_ticket_path(ticket.user_id, ticket.id), 
      :action => :destroy, 
      :method => :delete, 
      :confirm => t('admin.tickets.ticket.destroy_confirm', :ticket => ticket.nice_name),
      :class => 'btn'
    )
  end
  
  def ticket_edit_link(ticket, text)
    link_to(
      text, 
      edit_admin_user_ticket_path(ticket.user_id, ticket.id, :format => :js), 
      :remote => :true,
      :class => 'btn'
    )
  end
end
