class AddRecurringToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :recurring, :boolean, default: false
    add_column :tickets, :recurring_ticket_id, :integer
  end
end
