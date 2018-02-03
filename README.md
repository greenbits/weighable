<p align=center>
  <img src="https://cdn.rawgit.com/greenbits/weighable/rubygem-version-badge/logo.svg"
       height="130"
  >
</p>

<p align=center>
  <a href="https://rubygems.org/gems/weighable">
    <img src="https://img.shields.io/gem/v/weighable.svg?style=flat-square"
         alt="Rubygems homepage"></a>
  <a href="http://www.rubydoc.info/gems/weighable">
     <img src="https://img.shields.io/badge/rdoc-yes-brightgreen.svg?style=flat-square"
          alt="RDoc documentation"></a>
  <a href="https://circleci.com/gh/greenbits/weighable/tree/master">
     <img src="https://img.shields.io/circleci/project/github/greenbits/weighable.svg?style=flat-square"
          alt="CircleCI build status"></a>
  <a href="https://github.com/greenbits/weighable/issues">
     <img src="https://img.shields.io/github/issues/greenbits/weighable.svg?style=flat-square"
          alt="GitHub issues"></a>
</p>

<p align=center>
  A gem for dealing with weights in ruby and rails.
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weighable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weighable

## Usage

Using the weight class is as simple as:

```ruby
weight = Weighable::Weight.new(5, :gram)
weight = weight + Weighable::Weight.new(1, :ounce)
weight = weight.round(4)
```

This gets even cleaner when you include the core extensions (included by default with rails):

```ruby
require 'weighable/core_ext'
weight = 5.grams
weight = weight + 1.ounce
weight = weight.round(4)
```

## Usage with Rails

By default core extensions are included with rails. You also get some helpers to integrate weight
into active record.

Add a weight attribute to a model:

```ruby
class AddWeightToItem < ActiveRecord::Migration
  def change
    change_table :items do |t|
      t.weighable :my_weight
    end

    # OR

    add_weighable :items, :my_weight
  end
end

class Item < ActiveRecord::Base
  include Weighable::Model

  weighable :my_weight

  # OR require the field to be present

  weighable :my_weight, presence: true
end

# Now use it

item = Item.first
item.weight = 6.grams
item.save!
p item.weight == 6.grams # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greenbits/weighable.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
