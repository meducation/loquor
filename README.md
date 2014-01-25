# Loquor

[![Build Status](https://travis-ci.org/meducation/loquor.png)](https://travis-ci.org/meducation/loquor)
[![Dependencies](https://gemnasium.com/meducation/loquor.png?travis)](https://gemnasium.com/meducation/loquor)
[![Code Climate](https://codeclimate.com/github/meducation/loquor.png)](https://codeclimate.com/github/meducation/loquor)

Loquor handles calls to an API via an ActiveRecord-style interface. It is currently configured for the Meducation API but could easily be changed for any other API. It allows you to access show/index/update/create actions with simple calls like `MediaFile.find(8)`, without having to worry about HTTP, JSON or anything else.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'loquor'
```

And then execute:

    $ bundle

## Usage

To get going, you will want to set up some configuration variables.
``` ruby
Loquor.config do |config|
  config.access_id  = "Username"
  config.secret_key = "SecretKey1929292"
  config.endpoint   = "http://www.meducation.net"
  config.substitute_values[true]  = ":__true__"
  config.substitute_values[false] = ":__false__"
end
```

If you're not using this for Meducation, then edit the [mappings here](https://github.com/meducation/loquor/blob/master/lib/loquor.rb#L16).

Now you can make requests to get, create, update, destroy and list a range of objects, likein the same way you would interactive with an ActiveREcord object.

For example, you can get search objects using where:

```ruby
items = Loquor::User.where(email: "jeremy@meducation.net").where(name: "Jeremy")
# => [{id: 2, name: "Jeremy Walker"}, {id: 3, name: "Malcolm Landon"}]
```

Items responds to all the enumeration methods on Array. e.g.

```ruby
items.each do |user|
  p "The user with id ##{user['id']} is #{user['name']}."
end
```

The returned objects can be accessed as hashes (using either strings or symbols), or using dot notaton. e.g.:

```ruby
user = User.where(foo: 'bar').first
user.name
user['name']
user[:name]
```

You can use `select` (for api calls that support it), which specifies which fields to return.

```ruby
items = Loquor::User.select([:id, :name])
# => [{id: 2, name: "Jeremy Walker"}, {id: 3, name: "Malcolm Landon"}]
```
You can use `find` and `find_each` (which sends requests to the API in batches of 200)
```ruby
Loquor::User.find(2) # => {id: 2, name: "Jeremy Walker"}
Loquor::User.find_each do |user|
  # ...
end
```

You can also create users using the normal ActiveRecord method:
```ruby
Loquor::User.create(name: "Jeremy Walker", email: "jeremy@meducation.net") # => {id: 2, name: "Jeremy Walker", email "jeremy@meducation.net"}
```

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

## Contributing

Firstly, thank you!! :heart::sparkling_heart::heart:

We'd love to have you involved. Please read our [contributing guide](https://github.com/meducation/loquor/tree/master/CONTRIBUTING.md) for information on how to get stuck in.

### Contributors

This project is managed by the [Meducation team](http://company.meducation.net/about#team). 

These individuals have come up with the ideas and written the code that made this possible:

- [Jeremy Walker](http://github.com/iHiD)
- [Malcolm Landon](http://github.com/malcyL)
- [Charles Care](http://github.com/ccare)
- [Rob Styles](http://github.com/mmmmmrob)

## Licence

Copyright (C) 2013 New Media Education Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

A copy of the GNU Affero General Public License is available in [Licence.md](https://github.com/meducation/loquor/blob/master/LICENCE.md)
along with this program.  If not, see <http://www.gnu.org/licenses/>.
