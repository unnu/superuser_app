FactoryGirl.define do
  
  factory :user do
    first_name  { Forgery(:name).first_name }
    last_name   { Forgery(:name).last_name }
    email       { Forgery(:internet).email_address }
    nickname    { Forgery(:name).first_name + "_" + Forgery(:name).last_name }
    password    "geheim"
  end
  
  factory :ticket do
    name 'Foo'
    user
    start_time { Time.mktime(2011,11,1,0,0,0) }
    end_time { Time.mktime(2011,11,30,23,59,59) }
  end
  
  factory :block_ticket, :class => BlockTicket, :parent => :ticket do
    name "BlockTicket"
    type "BlockTicket"
    priority 500
    checkins_left 10
    end_time { Time.mktime(2011,11,30,23,59,59) }
    
    factory :expired_block_ticket do
      checkins_left 0
    end
    
    factory :recurring_block_ticket do
      recurring true
    end
  end
  
  factory :time_ticket, :class => TimeTicket, :parent => :ticket do
    name "TimeTicket"
    type "TimeTicket"
    priority 1000
    
    factory :expired_time_ticket, :class => TimeTicket do
      end_time { Time.mktime(2011,11,1,11,0,0) }
    end
  end
end
