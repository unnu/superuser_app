class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :mailchimp, :recoverable,
    :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :nickname

  has_many :tickets, dependent: :destroy
  has_many :checkin_tokens, dependent: :destroy
  has_many :time_tickets, :class_name => "TimeTicket"
  has_many :block_tickets, :class_name => "BlockTicket"
  
  validates_presence_of :first_name, :last_name, :nickname
  validates_uniqueness_of :nickname

  before_save :check_in!, :if => "current_sign_in_at_changed?"
  
  default_scope order('first_name, last_name')
  
  def display_name
    "#{first_name} #{last_name}"
  end

  def update_with_password(params = {})
    params.delete(:current_password)

    if params[:password] && params[:password_confirmation]
      self.update_attributes(params)
    else
      self.update_without_password(params)
    end
  end
  
  def current_ticket
    tickets.for_checkin.select { |ticket| !ticket.expired? }.first
  end
  
  private
    def check_in!
      if current_ticket
        current_ticket.check_in! unless current_ticket.expired?
      end
    end
end
