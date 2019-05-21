class UniqloShopper::CLI
  
  def call
    list_shirts
    clothes
    goodbye
  end
  
  def list_shirts
    puts "Today's T-Shirts:"
    @shirts = UniqloShopper::Shirt.today
    @shirts.each.with_index(1) do |shirt, i|
      puts "#{i}. #{shirt[:name]}"
    end
  end
  
  def clothes
    input = nil
    while input != "exit"
      puts "Which t-shirts would you like more information on or type list to see prices or type exit to exit:"
      input = gets.strip.downcase
      
      if input.to_i > 0
        the_shirt = @shirts[input.to_i-1]
        if the_shirt
          puts "#{the_shirt[:name]} - #{the_shirt[:price]} - #{the_shirt[:url]}
          "
        else
          puts "Error, please try again"
        end
      elsif input == "list"
        list_shirts
      else
        puts "Error, please try again"
      end
    end
  end
  
  def goodbye
    puts "Check at a later time for updates"
  end
  
end

