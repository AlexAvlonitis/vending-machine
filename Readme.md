# Vending Machine

An object oriented implementation of a vending machine, in ruby.

## Requirements

Design a vending machine in code. The vending machine should perform as follows:

- Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.

- It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.

- The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.

- There should be a way of reloading either products or change at a later point.

- The machine should keep track of the products and change that it contains.

## How to run

```ruby
irb
require './lib/vending_machine_factory'

vm = VendingMachineFactory.build
coin200 = Coin.new(200)

vm.show_products
vm.select_product(:coke)
vm.insert_coin(coin200)
vm.vend
```

## Tests
```
bundle install
rspec
```
