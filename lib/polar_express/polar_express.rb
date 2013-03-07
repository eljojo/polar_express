module PolarExpress
  # let's have the module behave like a class
  # http://stackoverflow.com/questions/318850/private-module-methods-in-ruby
  def self.new(*args)
    Tracker.new(*args)
  end
end
