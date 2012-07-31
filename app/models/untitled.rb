def each_reference_for(object)
  object.methods.select {|method| method =~ /_references\z/ }.each do |references|
    object.send(references).all.each do |reference|
      yield reference
    end
  end
end


Visit.all.each do |visit|
  visit.movements.all.each do |movement|
    each_reference_for(movement) do |reference|
      reference.destroy unless reference.valid?
    end
    
    # movement.waypoint_passages.all.each do |passage|
    #   each_reference_for(passage) do |reference|
    #     yield reference
    #   end
    # end
  end
end