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
info.percentage # => 100
info.statuses 
# [{:date=>
#    #<DateTime: 2012-12-05T15:52:00+08:00 ((2456267j,28320s,0n),+28800s,2299161j)>,
#   :city=>nil,
#   :status=>:shipping_instructions_received,
#   :text=>
#    "The instruction data for this shipment have been provided by the sender to DHL electronically"},
#  {:date=>
#    #<DateTime: 2012-12-05T19:47:00+08:00 ((2456267j,42420s,0n),+28800s,2299161j)>,
#   :city=>"Hagen",
#   :status=>:origin_distribution_center,
#   :text=>"The shipment has been processed in the parcel center of origin"},
#  {:date=>
#    #<DateTime: 2012-12-06T05:01:00+08:00 ((2456267j,75660s,0n),+28800s,2299161j)>,
#   :city=>"Rüdersdorf",
#   :status=>:destination_distribution_center,
#   :text=>"The shipment has been processed in the destination parcel center"},
#  {:date=>
#    #<DateTime: 2012-12-06T07:31:00+08:00 ((2456267j,84660s,0n),+28800s,2299161j)>,
#   :city=>"Berlin-Friedrichshain",
#   :status=>:in_delivery_vehicle,
#   :text=>"The shipment has been loaded onto the delivery vehicle"},
#  {:date=>
#    #<DateTime: 2012-12-06T07:32:00+08:00 ((2456267j,84720s,0n),+28800s,2299161j)>,
#   :city=>nil,
#   :status=>:in_delivery_vehicle_to_retail_outler,
#   :text=>"The shipment is on its way to the postal retail outlet."},
#  {:date=>
#    #<DateTime: 2012-12-06T17:46:00+08:00 ((2456268j,35160s,0n),+28800s,2299161j)>,
#   :city=>nil,
#   :status=>:waiting_for_pick_up_in_retail_office,
#   :text=>
#    "The shipment has been delivered for pick-up at the postal retail outlet Frankfurter Allee 71-77 10247 Berlin."},
#  {:date=>
#    #<DateTime: 2012-12-12T15:42:00+08:00 ((2456274j,27720s,0n),+28800s,2299161j)>,
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
