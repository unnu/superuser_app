class CheckinToken < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user_id, :token, :expires_at 

  class << self
    def generate
      Devise.friendly_token[0,20]
    end
  end

  def expired?
    expires_at < Time.now
  end
end