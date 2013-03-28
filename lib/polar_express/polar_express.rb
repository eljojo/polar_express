module PolarExpress
  # let's have the module behave like a class
  # http://stackoverflow.com/questions/318850/private-module-methods-in-ruby
  def self.new(*args)
    Tracker.new(*args)
  end
  
  # returns a courier's symbol given it's name.
  # ideally it should be much smarter, supporting company's name, etc.
  def self.identify_courier(name)
    case name.upcase
    when /DHL/
      :DHL
    when /GLS/
      :GLS
    when /HERMES/
      :Hermes
    end
  end
end
