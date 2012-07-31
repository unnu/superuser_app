every 1.day, :at => '00:01' do 
  rake 'tickets:recur:all'
end