module PolarExpress
  # let's have the module behave like a class
  def self.new(*args)
    Tracker.new(*args)
  end
end
