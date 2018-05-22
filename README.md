## About

This project is a banking application that was implemented following some of the best practices from Clean Architecture and Domain Driven Design. Rails was used as a delivery mechanism to interact with the core application.

## Requirements

- Ruby `2.5.0`
- PostgreSQL 9

## Setup

Install docker [here](https://docs.docker.com/install/) and the get PostgreSQL (or get it running some other way):

```bash
$ docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD= -d postgres:9
```

Setup the application and run the tests:

```bash
$ bin/setup
$ bundle exec rspec
```

Optional Bonus:

```
$ # Run tests for each commit:
$ git log --oneline | awk '{print $1}' | tail -r | while read sha ; do ; git checkout "$sha" && bundle exec rspec ; done && git checkout master
```

Open the console:

```
$ bin/rails c
```

And create two accounts in the rails console:

```ruby
(0..1).map { Account.create(balance: 1000) }

=> [#<Account:0x00007fc7a15b0728
  id: 1,
  balance: 0.1e4,
  created_at: Mon, 21 May 2018 02:23:21 UTC +00:00,
  updated_at: Mon, 21 May 2018 02:23:21 UTC +00:00>,
 #<Account:0x00007fc7a28b7678
  id: 2,
  balance: 0.1e4,
  created_at: Mon, 21 May 2018 02:23:21 UTC +00:00,
  updated_at: Mon, 21 May 2018 02:23:21 UTC +00:00>]
```

Then start the server:

```bash
$ bin/rails s
```

## Use cases

To prettify the JSON output in the following commands, you can use `jq`. You can download it [here](https://stedolan.github.io/jq/). 

This application implements the following use cases:

### Get current balance from an account

**Endpoint**

```
GET /accounts/:id
```

**Required Inputs**

- `:id` - Account id in the system

####Example

```bash
$ curl -s http://localhost:3000/accounts/1 | jq

HTTP/1.1 200 OK
{
  "data": {
    "account_id": "1",
    "balance": {
      "amount": "1000.0"
    }
  }
}
```

####Possible errors

**Inexistent account**

```bash
$ curl -s http://localhost:3000/accounts/-1 | jq

HTTP/1.1 404 Not Found
{
  "data": {
    "errors": [
      "account_not_found"
    ]
  }
}
```

### Transfer Money between two accounts

**Endpoint**

```
POST /transfers
```

**Required Inputs**

- `:amount` - Amount in BRL to be moved between the two accounts
- `:source_account_id` - Id of the account that is going to send the money
- `:destination_account_id` - Id of the account that will receive the money

####Example

```bash
$ curl -s -X POST http://localhost:3000/transfers -d \
 'amount=100&source_account_id=1&destination_account_id=2' | jq

HTTP/1.1 200 OK
{
  "data": {
    "status": "ok"
  }
}

$ curl -s http://localhost:3000/accounts/1 | jq
{
  "data": {
    "account_id": "1",
    "balance": {
      "amount": "900.0"
    }
  }
}

$ curl -s http://localhost:3000/accounts/2 | jq
{
  "data": {
    "account_id": "2",
    "balance": {
      "amount": "1100.0"
    }
  }
}
```

####Possible errors

**Inexistent account**

```bash
$ curl -s -X POST http://localhost:3000/transfers -d \
 'amount=100&source_account_id=-1&destination_account_id=2' | jq

HTTP/1.1 404 Not Found
{
  "data": {
    "errors": [
      "account_not_found"
    ]
  }
}
```

**Negative amount**

```bash
$ curl -s -X POST http://localhost:3000/transfers -d \
 'amount=-100&source_account_id=1&destination_account_id=2' | jq

HTTP/1.1 400 Bad Request
{
  "data": {
    "errors": [
      "negative_amount"
    ]
  }
}
```

**Insufficient Balance**

```bash
$ curl -s -X POST http://localhost:3000/transfers -d \
 'amount=99999&source_account_id=1&destination_account_id=2' | jq

HTTP/1.1 400 Bad Request
{
  "data": {
    "errors": [
      "insufficient_balance"
    ]
  }
}
```

## Architecture and Design

This application was designed following the [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) pattern.

![](https://8thlight.com/blog/assets/posts/2012-08-13-the-clean-architecture/CleanArchitecture-8d1fe066e8f7fa9c7d8e84c1a6b0e2b74b2c670ff8052828f4a7e73fcbbc698c.jpg)

**Folder Structure**

```
- app
    - controllers
    - model
    - domain
        - entities
        - repositories
        - use_cases 
```

- `controllers` - Simple Rails controllers.
- `model` - Rails models that are used inside repositories to interact with our persistence layer.
- `domain/entities` - Classes representing entities from our domain. Most notably an `Account` entity and a `Transaction` entity.
- `domain/repositories` - Repository implementation using the `ActiveRecord` gem.
- `domain/use_cases` - Use cases implementation.

**Value objects**

Inside the `domain` folder we also have a value object `Money`. I did not create a specific folder for value objects since I've chosen to use Rails autoload (otherwise my life would be harder) and I also didn't want to have a namespace for value objects. 

**Framework independency**

Every domain class was designed to be framework independent and you can see this by looking at their respective test's files. Each test just uses what is necessary and they only load the Rails framework when it is needed. You can see that Rails is not loaded by default by looking at the `.rspec` file. And to see that each test can be executed in isolation, that is, only interacting with its dependencies, you can run all of them, one by one, with the following command:

```
$ find spec -iname '*_spec.rb' -type f -exec rspec {} ';'
```

As a consequence, you can find each class dependencies in the `require` statements in each test file. I would prefer to keep those `require` statements together with the production code, since I think it is a nice way to be explicit about your dependencies. But Rails [autoload feature does not play nicely with require's](http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-and-require), so I had to leave them inside the test file.

**Dependency Injection**

The application has a container called `Context` that help us to do dependency injection. You can register some object in this container and then use it in your class later. Using this approach we can boot our application with different dependencies depending on our environment. One thing we could do with this, for example, is run our tests with real dependencies on our CI (use `rails_helper` in the `.rspec` file) and run with fake ones locally (use `spec_helper` in the `.rspec` file). I had to leave this class inside the `config/initializers` folder since Rails reload all the code, except the initializers, every time we change something, and that would break the container in development mode. 

**Concurrency in the transfer use case**

To implement the `UseCases::Transfer` I've chosen to use pessimist locking in order to update each account balance and prevent dirty reads. Another possible approach would be to persist an event in the database and use Event Sourcing and eventual consistency to implement this use case. Although Event Sourcing could yield a solution that results in more availability and performance I've chosen to keep it simpler here.

**Interface with the framework**

The current implementation uses a `UseCases::Result` class to act as the "Use Case Output Port" interface between the `Controller` and each `UseCase`.

**Final thoughts**

I did not paid too much attention to other details that would be extremely critical in a real banking application like security concerns, authorization, authentication, etc, since I felt the purpose of this exercise was to evaluate the application design and architecture.