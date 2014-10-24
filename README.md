DpdApi
======

:small_red_triangle_down: Ruby implementation for [DPD](http://dpd.ru)'s SOAP API

[![Gem Version](https://badge.fury.io/rb/dpd_api.svg)](http://badge.fury.io/rb/dpd_api)
[![Build Status](https://travis-ci.org/itsNikolay/dpd_api.svg)](https://travis-ci.org/itsNikolay/dpd_api)
[![Code Climate](https://codeclimate.com/github/itsNikolay/dpd_api/badges/gpa.svg)](https://codeclimate.com/github/itsNikolay/dpd_api)
[![Test Coverage](https://codeclimate.com/github/itsNikolay/dpd_api/badges/coverage.svg)](https://codeclimate.com/github/itsNikolay/dpd_api)

Installation
------------

### Rails

```ruby
# Gemfile
gem 'dpd_api'
```

```ruby
# config/initializers/dpd_api.rb
DpdApi.configure do |config|
  config.client_key    = 'ASD7686ASD76786786786786AASD'
  config.client_number = '123456789'
  config.base_url = Rails.env.production? ? 'http://ws.dpd.ru' : 'http://wstest.dpd.ru'
  config.debug = Rails.env.production? ? false : true
end
```

### Ruby
```ruby
gem install dpd_api
```

```ruby
require 'dpd_api'

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

Table of content
----------------
* [NOTES](#notes)
* [DpdApi::Geography](#dpdapigeography)
  * [.cities_cash_pay](#cities_cash_pay)
  * [.terminals_self_delivery](#terminals_self_delivery)
  * [.parcel_shops](#parcel_shops)
* [DpdApi::Calculator](#dpdapicalculator)
  * [.service_cost](#service_cost)
  * [.service_cost_by_parcels](#service_cost_by_parcels)
* [DpdApi::Order](#dpdapiorder)
  * [.create_order](#create_order)
  * [.order_status](#order_status)
  * [.create_address](#create_address)
  * [.update_address](#update_address)
  * [.cancel_order](#cancel_order)
  * [.add_parcels](#add_parcels)
  * [.remove_parcels](#remove_parcels)
  * [.invoice_file](#invoice_file)
* [DpdApi::Tracing](#dpdapitracing)
  * [.states_by_client_order](#states_by_client_order)
  * [.states_by_client_parcel](#states_by_client_parcel)
  * [.states_by_dpd_order](#states_by_dpd_order)
* [DpdApi::Nl](#dpdapinl)
  * [.nl_amount](#nl_amount)
  * [.nl_invoice](#nl_invoice)
* [DpdApi::LabelPrint](#dpdapilabelprint)
  * [.create_label_file](#create_label_file)

Notes
-----
1. The gem is based on gem [savon](https://github.com/savonrb/savon) v.2
2. Naming: java's `#getOrderStatus` becomes ruby's `#order_status`

Getting started
---------------

### DpdApi::Geography
matches `/services/geography?wsdl` in DPD SOAP API

####.cities_cash_pay
matches `getCitiesCashPay`
```ruby
DpdApi::Geography.cities_cash_pay

# => [{
        city_id:      "48951627",
        country_code: "RU",
        country_name: "Россия",
        region_code:  "42",
        region_name:  "Кемеровская",
        city_name:    "Кемерово"
      }, . . . ]

```

####.terminals_self_delivery
matches `getTerminalsSelfDelivery2`
```ruby
DpdApi::Geography.terminals_self_delivery

# => [{
      terminal: {
        terminal_code:    "ABA",
        terminal_name:    "Абакан - терминал",
        terminal_address: "655004, Хакасия респ., г. Абакан, ул. Игарская, д. 10",
        geo_coordinates: {
          geo_x: "53.710113",
          geo_y: "91.392873"
        },
        working_time: {
          week_days: "Пн,Вт,Ср,Чт,Пт,Сб,Вс",
          work_time: "09:00 - 18:00"
        }
      },
      city: {
        city_id:      "195851995",
        country_code: "RU",
        country_name: "Россия",
        region_code:  "19",
        region_name:  "Хакасия",
        city_code:    "19000001000",
        city_name:    "Абакан"
      }
    }, . . . ]

```

####.parcel_shops
matches `?` there's no method in documentation
```ruby
params = {} # or without
DpdApi::Geography.parcel_shops(params)

# => [{
      code:             "01A",
      parcel_shop_type: "ПВП",
      address: {
        country_code:   "RU",
        region_code:    "61",
        region_name:    "Ростовская",
        city_code:      "61000001000",
        city_name:      "Ростов-на-Дону",
        address_string: "344038, Ростовская обл., г. Ростов-на-Дону, пр-т Ленина, д. 115"
      },
      geo_coordinates: {
        geo_x: "47.249054",
        geo_y: "39.722657"
      },
      limits: {
        max_weight: "31",
        max_length: "100",
        max_width:  "100",
        max_height: "100"
      },
      working_time: [
        {
          week_days: "Пн,Вт,Ср,Чт,Пт,Сб",
          work_time: "09:00 - 20:00"
        },
        {
          week_days: "Вс",
          work_time: "выходной"
        }
      ]
    }, . . . ]

```

### DpdApi::Calculator
matches `/services/calculator2?wsdl` in DPD SOAP API

####.service_cost
matches `getSeviceCost2`
```ruby
params = { pickup:   { city_id: 195851995 },
           delivery: { city_id: 48951627 },
           self_pickup:   false,
           self_delivery: false,
           weight: 1, }

DpdApi::Calculator.service_cost(params)

# => [{
        service_code: "TEN",
        service_name: "DPD 10:00",
        cost:         "2228.67",
        days:         "4"
      }, . . . ]

```

####.service_cost_by_parcels
matches `getServiceCostByParcels2`
```ruby
params = {
            pickup:   { city_id: 195851995 },
            delivery: { city_id: 48951627 },
            self_pickup:   true,
            self_delivery: true,
            parcel: {
                weight: 0.5,
                length: 0.5,
                width:  0.5,
                height: 0.5,
            },
            parcel: {
                weight: 1,
                length: 1,
                width:  1,
                height: 1,
            },
         }

DpdApi::Calculator.service_cost_by_parcels(params)

# => [{
        service_code: "TEN",
        service_name: "DPD 10:00",
        cost:         "551.65",
        days:         "4"
     }, . . . ]

```

### DpdApi::Order
matches `/services/order2?wsdl`

####.create_order
matches `createOrder`
```ruby
params = {
            header: {
                date_pickup: date,
                sender_address: {
                    name: fio,
                    terminal_code: 'ABA',
                    city: 'Москва',
                    street: 'Ленина',
                    street_abbr: 'ул',
                    house: 1,
                    contact_fio: fio,
                    contact_phone: '+79211234567',
                },
            },
            order: [
                {
                    order_number_internal: '1234567',
                    service_code: 'TEN',
                    service_variant: 'ТД',
                    cargo_num_pack: '1',
                    cargo_weight: '1',
                    cargo_registered: false,
                    cargo_category: 'Одежда',
                    receiver_address: {
                        name: fio,
                        terminal_code: '',
                        city: 'Воронеж',
                        street: 'Красноармейская',
                        street_abbr: 'ул',
                        house: 1,
                        contact_fio: fio,
                        contact_phone: '+79211234567',
                    },
                    parcel: [
                        {
                            number: '123456789',
                        },
                    ],
                },
            ],
        }

DpdApi::Order.create_order(params)

# => [{
        order_number_internal: "1234567",
        order_num: "10160002MOW",
        status: "OK",
        error_message:  nil,
     }]

```

####.order_status
matches `getOrderStatus`
```ruby
params = {
            order: {
                order_number_internal: '123456',
            }
         }


DpdApi::Order.order_status(params)

# => [{
        order_number_internal: "123456",
        order_num: "10160001MOW",
        status: "OK",
     }]


```
####.create_address
matches `createAddress`
```ruby
params = {
            client_address: {
                code: '78',
                name: fio,
                city: 'Воронеж',
                street: 'Красноармейская',
                street_abbr: 'ул',
                house: 1,
                contact_fio: fio,
                contact_phone: '+79211234567',
            },
         }



DpdApi::Order.create_address(params)

# => [{
         code:   "78",
         status: "OK",
     }]


```
####.update_address
matches `updateAddress`
```ruby
params = {
            client_address: {
                code: '78',
                name: fio,
                city: 'Воронеж',
                street: 'Красноармейская',
                street_abbr: 'ул',
                house: 1,
                contact_fio: fio,
                contact_phone: '+79200000000',
            },
         }




DpdApi::Order.update_address(params)

# => [{
         code:   "78",
         status: "OK",
     }]
```

####.cancel_order
matches `cancelOrder`
```ruby
params = {
            cancel: {
                order_num: '10160001MOW',
            },
         }

DpdApi::Order.cancel_order(params)

# => [{
        order_number_internal: "123456",
        order_num: "10160001MOW",
        status: "Canceled",
     }]

```

####.add_parcels
matches `addParcels`
```ruby
params = {
            order_num: '10160001MOW',
            cargo_num_pack: '2',
            cargo_weight: '2',
            cargo_category: 'Одежда',
            parcel: [
                { number: '987654321' },
                { number: '5678' },
            ],
        }

DpdApi::Order.add_parcels(params)

# => {
        order_num: "10160001MOW",
        status:    "OK",
        parcel_status: [
            {
                number: "987654321",
                status: "OK",
            },
            {
                number: "5678",
                status: "OK"
            }
        ]
     }

```

####.remove_parcels
matches `removeParcels`
```ruby
params = {
            order_num: '10160001MOW',
            cargo_num_pack: '1',
            cargo_weight: '1',
            cargo_category: 'Одежда',
            parcel: [
                {
                    number: '987654321',
                },
            ],
         }


DpdApi::Order.remove_parcels(params)

# => {
        order_num: "10160001MOW",
        status: "OK",
        parcel_status: {
            number: "987654321",
            status: "OK",
        },
     }


```


####.invoice_file
matches `getInvoiceFile`
```ruby
params = { order_num: '10160002MOW' }

DpdApi::Order.invoice_file(params)

# => {
        file: 'JVBERi0xLjQKJeLj . . .'
     }
```


### DpdApi::Tracing
matches `/services/tracing1-1?wsdl` in DPD SOAP API

####.states_by_client_order
matches `getStatesByClientOrder`
```ruby
params = {
            client_order_nr: '12345',
         }

DpdApi::Tracing.states_by_client_order(params)

```

####.states_by_client_parcel
matches `getStatesByClientParcel`
```ruby
params = {
            client_parcel_nr: '987654321',
         }

DpdApi::Tracing.states_by_client_parcel(params)

```

####.states_by_dpd_order
matches `getStatesByDpdOrder`
```ruby
params = {
            client_parcel_nr: '987654321',
         }

DpdApi::Tracing.states_by_dpd_order(params)

```


### DpdApi::Nl
matches `/services/nl?wsdl` in DPD SOAP API

####.nl_amount
matches `getNLAmount`
```ruby
params = {
            date_from: Time.now - 1.days,
            date_to:   Time.now + 1 days,
          }

DpdApi::Tracing.nl_amount(params)

```
####.nl_invoice
matches `getNLInvoice`
```ruby
params = {
            date_from: Time.now - 1.days,
            date_to:   Time.now + 1 days,
          }

DpdApi::Tracing.nl_invoice(params)

```


### DpdApi::LabelPrint
matches `/services/label-print?wsdl` in DPD SOAP API

####.create_label_file
matches `createLabelFile`
```ruby
params = {
          file_format: 'PDF',
          page_size: 'A5',
          order: [
            order_num: '10160002MOW',
            parcels_number: '2',
          ],
        }

DpdApi::Tracing.create_label_file(params)

```
