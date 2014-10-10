DpdApi
======

:small_red_triangle_down: Ruby implementation for [DPD](http://dpd.ru)'s SOAP API

Installation
------------

### Rails

```ruby
# config/initializers/dpd_api.rb

DpdApi.configure do |config|
  # your dpd's given client key and client number
  config.client_key    = 'ASD7686ASD76786786786786AASD'
  config.client_number = '123456789'
  config.base_url = Rails.env.production? ? 'http://ws.dpd.ru' : 'http://wstest.dpd.ru'
end
```

### Ruby
```ruby
client_key    = 'ASD7686ASD76786786786786AASD'
client_number = '123456789'
DpdApi.configure { |c| c.client_key = client_key; c.client_number = client_number; }
```

Quickstart
----------

```ruby
params = { pickup:   { city_id: 195851995 },
           delivery: { city_id: 48951627 },
           self_pickup:   false,
           self_delivery: false,
           weight: 1, }

DpdApi::Calculator.service_cost(params)

#=> [{:service_code=>"TEN", :service_name=>"DPD 10:00", :cost=>"2228.67", :days=>"4"}, {:service_code=>"DPT", :service_name=>"DPD 13:00", :cost=>"1966.47", :days=>"4"}, . . .]
```
