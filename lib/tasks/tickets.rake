namespace :tickets do
  namespace :recur do
    
    desc "recur all tickets"
    task :all => :environment do
      Ticket.recur_all!
    end
  end
end