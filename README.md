# PlainQuery ![transp_logo_153](https://user-images.githubusercontent.com/95882437/189980991-9417395b-ff94-4480-89a5-bb97c9aaf8ca.png)

PlainQuery is a simple gem that helps you write clear and flexible query objects.
Main task for this gem is performing complex querying on active record relation, make it intuitive.

It helps in decomposing your fat ActiveRecord models and keeping your code slim and readable by extracting complex SQL queries or scopes into the separated classes that are easy to write, read and use.

PlainQuery is useful when you need to build one or more queries based on incoming parameters in the request. It hides scope building logic inside query class and allows you to structure the building of the scope.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'plain_query'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plain_query

## Why it may be usefull to you
1. Creates standard for database query logic
2. Keeps query logic in one place
3. Removes query logic from models
4. Makes complicated queries easy to build, read and change
5. Queries are really flexible and modular
6. Queries are compatible with standard Rails model scopes

## Usage
### Setting up a query object
For setting up a query object you need to include PlainQuery::Base into your your query class.
Then you need to describe query steps by using query_step method.
Query steps perform in writing order.

```rb
class UsersQuery
  include PlainQuery::Base(model: User)

  query_step :filter_by_activity, if: -> { options[:only_active] }
  query_step :filter_by_phone_presence, query: UsersWithPhoneQuery
  query_step :order_by_name

  def filter_by_activity
    relation.where(active: true)
  end

  def order_by_name
    relation.order(name: :asc)
  end
end
```

### Query calling

```rb
users = UsersQuery.call(User.all, only_active: true)
```

Query object implements `#call` method with two arguments:

`relation` - Base scope which will be mutated inside query object. (`User.all` in example).
If you dont pass it - will be used default scope from model declaration from PlainQuery::Base module include `include PlainQuery::Base(model: User)`.

`options` - Any data which will be used inside query steps or execution conditions. (`only_active: true` in example).

Query object returns scope builded by ordered query steps execution.

### query_step
`query_step` is a main part of query building.

It declares which query change method will be executed, condition of execution and order of query change methods execution.

It has several arguments:

```rb
query_step STEP_NAME, EXECUTION_OPTIONS
```

`STEP_NAME` is a name of method which will be executed.

`EXECUTION_OPTIONS` is a collection of options related with step execution.
Available two types of options:
`Condition` - allows or denieds execution of query step. Type of condition can be `if:` or `unless:`. Condition definition can be proc (lambda) or some query object method name. Result of query object method used in condition will be used as a boolean value.
`Nested query` - realises DI for current query object by `query` key. It can execute any class which has call method and returns relation.

### Using in Active Record model scope.
First of all you need to set correct model name inside query object.

It uses for correct base scope building without passing relation to query object.

```rb
include PlainQuery::Base(model: User)
```

```rb
class ActiveClientsQuery
  include PlainQuery::Base(model: User)

  query_step :filter_by_activity
  query_step :filter_by_role

  def filter_by_activity
    relation.where(active: true)
  end

  def filter_by_role
    relation.where(role: :client)
  end
end
```

```rb
class User < ActiveRecord::Base
  scope :active_clients, ActiveClientsQuery
end
```

And then you can use scope from model:

```rb
User.active_clients
```

Also you can pass to Active Record scope some options:

```rb
class User < ActiveRecord::Base
  scope :active_clients, -> { ActiveClientsQuery.call(self, option: true) }
end
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
