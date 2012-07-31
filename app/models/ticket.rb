class Ticket < ActiveRecord::Base
  class TicketExpiredError < StandardError; end
  class NotRecurableError < StandardError; end
  class AllreadyRecurredError < StandardError; end

  belongs_to :user
  attr_accessible :user_id, :start_time, :end_time, :type, :checkins_left, :name, :priority, :recurring_ticket_id, :recurring
  before_create :add_default_attributes
  validates_presence_of :user_id, :start_time, :type, :name
  
  scope :current, lambda { now = Time.zone.now; where("tickets.start_time <= ? AND tickets.end_time >= ?", now, now) }
  scope :expired, lambda { where("tickets.end_time < ?", Time.zone.now) }
  scope :active, lambda { where("tickets.end_time >= ?", Time.zone.now) }
  
  scope :prioritized, order("tickets.priority DESC")
  scope :expires_first, order("tickets.end_time ASC")
  
  scope :prioritized_for_checkin, lambda { prioritized.expires_first }
  scope :for_checkin, lambda { current.prioritized_for_checkin }
  
  scope :recurring, lambda {
    expired.where(recurring: true).
    joins("LEFT OUTER JOIN tickets AS recurring_tickets on tickets.id = recurring_tickets.recurring_ticket_id").
    where('recurring_tickets.id IS NULL')
  }
  
  class << self 
    def options_from_yaml
      load_tickets.map do |ticket|
        [ticket["name"] + " Ticket", ticket["name"] + "_" + ticket["type"]]
      end
    end
    
    def end_time_for(name, start_time)
      validity = parse_validity(load_tickets.select { |ticket| ticket["name"] == name }.first["valid"])
      (start_time + validity - 1.second)
    end
    
    def default_checkins_for(name)
      load_tickets.select { |ticket| ticket["name"] == name }.first["checkins"]
    end
    
    def priority_for(name)
      load_tickets.select { |ticket| ticket["name"] == name }.first["priority"]
    end
    
    def recurring_for(name)
      load_tickets.select { |ticket| ticket["name"] == name }.first["recurring"]
    end

    def new_from_params(params)
      params["name"], params["type"] = params["type"].split("_")
      raise ArgumentError unless %w(BlockTicket TimeTicket).include?(params["type"])
      
      params["type"].constantize.new(params)
    end
    
    def recur_all!
      recurring.each do |ticket|
        ticket.recur!
      end
    end

    private
      def load_tickets
        YAML::load_file("#{Rails.root}/config/tickets_#{Rails.env}.yml")
      end
    
      def parse_validity(string)
        amount, time = string.split("_")
        
        case time
          when "D" then amount.to_i.days
          when "M" then amount.to_i.months
          when "Y" then amount.to_i.years
        end
      end
  end

  def expired?
    raise NotImplementedError
  end
  
  def check_in!
    raise NotImplementedError
  end
  
  def editable?
    end_time >= Time.zone.now
  end
  
  def nice_name
    name + " Ticket"
  end
  
  def recur!
    raise NotRecurableError unless recurring?
    raise AllreadyRecurredError if recurred?
    
    self.class.create!(
      user_id: user.id,
      name: name,
      start_time: end_time + 1.second,
      recurring_ticket_id: id,
      recurring: true
    )
  end
  
  def recurred?
    Ticket.exists?(recurring_ticket_id: id)
  end
  
  private
    def add_default_attributes
      raise NotImplementedError
    end
end

