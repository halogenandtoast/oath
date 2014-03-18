# Monban 門番

[![Build Status](https://travis-ci.org/halogenandtoast/monban.png?branch=master)](https://travis-ci.org/halogenandtoast/monban)
[![Code Climate](https://codeclimate.com/github/halogenandtoast/monban.png)](https://codeclimate.com/github/halogenandtoast/monban)


Monban is designed to be a very simple and extensible user authentication
library for rails. Its goal is to give all the power to the developer instead
of forcing them to make Monban work with their system.

# Why use Monban?

Monban makes authentication simple:

- Easy to use in tests with dependency injection
- Provides convenient controller helpers
- Very customizable

Monban doesn't do the following:

- Doesn't automatically add routes to your application
- Doesn't force you to use engine based controllers or views
- Doesn't require you to make changes to your user model


## Installation

Monban was designed to work with Rails > 4.0. Add this line to your Gemfile:

    gem 'monban'

Then inside of your ApplicationController add the following:

    include Monban::ControllerHelpers

And you're ready to start designing your authentication system.

## Scaffold

If you don't want to add all the components yourself, you may instead generate
a scaffold to start with by running:

    rails g monban:scaffold

This will generate a bare bones starting point. If you don't want the full
stack you can just generate some controllers with:

    rails g monban:controllers

## Usage

Monban does currently have some out of the box expectations, but you can
configure and change any of these:

- By default the model should be called `User`
- Monban expects your user model to respond to create
- You should have an `email` and `password_digest` column on your `User`
- Passwords will be handled with BCrypt

### Controller Additions

Monban provides the following controller methods:

- `sign_in(user)`
- `sign_out`
- `sign_up(user)`
- `authenticate(user, password)`
- `authenticate_session(session_params)`
- `reset_password(user, password)`

These helpers:

- `current_user`
- `signed_in?`

And this filter:

- `require_login`

## Usage in Tests

### Test mode

Monban provides the following:

```ruby
Monban.test_mode!
```

Which will change password encryption to provide plaintext responses instead of using BCrypt. This will allow you to write factories using the password_digest field:

```ruby
FactoryGirl.define do
  factory :user do
    username 'wombat'
    password_digest 'password'
  end
end
```

### Spec helpers

A couple of convenience methods are available in your tests.

```ruby
Monban.test_mode!

RSpec.configure do |config|
  config.include Monban::Test::Helpers, type: :feature
  config.after :each do
    Monban.test_reset!
  end
end
```

```ruby
feature "A feature spec" do
  scenario "that requires login" do
    user = create(:user)
    sign_in(user)
    # do something
    sign_out
    # do something else
  end
end
```

### Controller Specs

If you are going to write controller tests, helpers are provided for those as well:

```ruby
Monban.test_mode!

RSpec.configure do |config|
  config.include Monban::Test::ControllerHelpers, type: :controller
  config.after :each do
    Monban.test_reset!
  end
end
```

```ruby
require 'spec_helper'

describe ProtectedController do

  describe "GET 'index'" do
    it "returns http success when signed in" do
      user = create(:user)
      sign_in(user)
      get 'index'
      response.should be_success
    end

    it "redirects when not signed in" do
      get 'index'
      response.should be_redirect
    end
  end
end
```

## Advanced Functionality

You may perform a look up on a user using multiple fields by doing something like the following:

```ruby
class SessionsController < ApplicationController
  def create
    user = authenticate_session(session_params, email_or_username: [:email, :username])
    sign_in(user) do
      redirect_to(root_path) and return
    end
    render :new
  end

  private

  def session_params
    params.require(:session).permit(:email_or_username, :password)
  end

end
```

This will allow the user to enter either their username or email to login

### Limitations

Here are a few of the current limitations of monban:

- Monban assumes you only have one user model.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
