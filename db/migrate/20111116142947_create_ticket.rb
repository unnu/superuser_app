class CreateTicket < ActiveRecord::Migration
def self.up
    create_table(:tickets) do |t|
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :checkins_left 
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
