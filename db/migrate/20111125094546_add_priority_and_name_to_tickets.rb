class AddPriorityAndNameToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :priority, :integer
    add_column :tickets, :name, :string
  end
end
