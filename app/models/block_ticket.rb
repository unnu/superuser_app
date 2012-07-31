class BlockTicket < Ticket
  
  class << self
    def nice_name
      "Block Ticket"
    end
  end
  
  def expired?
    checkins_left <= 0 || end_time < Time.zone.now
  end
  
  def check_in!
    raise Ticket::TicketExpiredError if expired?

    unless CheckinToken.where("user_id = ? AND expires_at > ?", user_id, Time.zone.now).any?
      transaction do
        CheckinToken.create!(:user_id => user_id, :token => CheckinToken.generate, :expires_at => expiration_date)
        self.checkins_left -= 1
        self.save!
      end
    end
  end
  
  private
    def expiration_date
      now = Time.zone.now
      Time.mktime(now.year, now.month, now.day, 23, 59, 59)
    end
    
    def add_default_attributes
      self.end_time ||= Ticket.end_time_for(name, start_time)
      self.checkins_left ||= Ticket.default_checkins_for(name)
      self.priority ||= Ticket.priority_for(name)
      # not using ||= assignment here because true/false values
      self.recurring = Ticket.recurring_for(name) if recurring.nil?
      true
    end
end