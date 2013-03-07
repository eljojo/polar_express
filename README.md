# Polar Express

Get on board of The Polar Express and let's have a train ride to package tracking!

## Gem in development
Note: this gem is in current development, so don't expect anything to work yet (not even the usage example!!!)

Feel free to contribute to the project :)

## Installation

Add this line to your application's Gemfile:

    gem 'polar_express'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polar_express

## Usage

```ruby
@tracker = PolarExpress.new('DHL', '017219678663')
info = @tracker.track!
info.status # => :delivered
info.statuses 
# [{:date=>
#    #<DateTime: 2012-12-05T15:52:00+08:00>,
#   :city=>nil,
#   :status=>:shipping_instructions_received,
#   :text=>
#    "The instruction data for this shipment have been provided by the sender to DHL electronically"},
#  {:date=>
#    #<DateTime: 2012-12-06T07:31:00+08:00>,
#   :city=>"Berlin-Friedrichshain",
#   :status=>:in_delivery_vehicle,
#   :text=>"The shipment has been loaded onto the delivery vehicle"},
#  {:date=>
#    #<DateTime: 2012-12-12T15:42:00+08:00>,
#   :city=>nil,
#   :status=>:delivered,
#   :text=>"The recipient has picked up the shipment from the retail outlet"}]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


### What can I help with?
- work on DHL implementation
- write more tests
- documentation. rdoc?
- discuss about the structure of the gem. is there space for improvement?
