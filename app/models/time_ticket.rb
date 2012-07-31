class TimeTicket < Ticket
  
  class << self
    def nice_name
      "Time Ticket"
    end
  end

  def expired?
    end_time < Time.zone.now
  end

  def check_in!
    raise Ticket::TicketExpiredError if expired?
    
    unless CheckinToken.where("user_id = ? AND expires_at > ?", user_id, Time.zone.now).any?
      CheckinToken.create!(:user_id => user_id, :token => CheckinToken.generate, :expires_at => end_time)
    end
  end
  
  private
    def add_default_attributes
      self.end_time ||= Ticket.end_time_for(name, start_time)
      self.priority ||= Ticket.priority_for(name)
      # not using ||= assignment here because true/false values
      self.recurring = Ticket.recurring_for(name) if recurring.nil?
      true
    end
end