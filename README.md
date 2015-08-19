Ruby wrapper for Payeer API

## Installation

```ruby

gem 'payeer'

```

## Usage

```ruby

   # Using Payeer API
   client = Payeer.new ACCOUNT, API_ID, API_SECRET, log: true

   client.balance

   client.transfer_funds currency_from: 'USD',
                         currency_to: 'USD',
                         amount: 100,
                         to: 'P21602373',
                         comment: 'my payment'

   client.transaction_history transaction_id

```