module PolarExpress
  # let's have the module behave like a class
  def self.new(*args)
    Tracker.new(*args)
  end
  
  # returns a courier's symbol given it's name.
  # ideally it should be much smarter, supporting company's name, etc.
  def self.identify_courier(name)
    case name.upcase
    when 'DHL'
      :DHL
    end
  end
end
