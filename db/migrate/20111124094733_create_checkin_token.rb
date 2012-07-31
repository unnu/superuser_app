class CreateCheckinToken < ActiveRecord::Migration
def self.up
    create_table(:checkin_tokens) do |t|
      t.integer :user_id
      t.datetime :expires_at
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :checkin_token
  end
end
