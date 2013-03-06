# Polar Express

Get on board of The Polar Express and let's have a train ride to package tracking!

# Gem in development
Note: this gem is in current development, so don't expect anything to work yet (not even the usage example!!!)
Feel free to contribute to the project :)

## Installation

Add this line to your application's Gemfile:

    gem 'polar_express'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polar_express

## Usage from your Rails Controllers

```ruby
info = PolarExpress.new('DHL', '123456789').track!
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


### What can I help with?
- discuss about the structure of the gem. is there space for improvement?
- work on DHL implementation
- write more tests
