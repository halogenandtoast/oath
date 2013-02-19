# Monban 門番

[![Build Status](https://travis-ci.org/halogenandtoast/monban.png?branch=master)](https://travis-ci.org/halogenandtoast/monban)
[![Code Climate](https://codeclimate.com/github/halogenandtoast/monban.png)](https://codeclimate.com/github/halogenandtoast/monban)


Monban is designed to be very simple and extensible user authentication. It's goal is to give all the power to the developer instead of
forcing them to make Monban work with their system

# Why use Monban?

Monban makes authentication simple:

- Uses warden
- Provides convenient controller helpers
- Provides a rails generator for default controllers and views
- TODO: Very customizable

Monban doesn't do the following:

- Doesn't automatically add routes to your application
- Doesn't force you to use engine based controllers or views
- Doesn't require you to make changes to your user model


## Installation

Monban was designed to work with Rails > 3.1. Add this line to your Gemfile:

    gem 'monban'

Then inside of your ApplicationController add the following:

    include Monban::ControllerHelpers

You may also generate a scaffold to start with:

    rails g monban:scaffold

This will generate a bare bones starting point. If you don't want the full stack you can just generate some controllers with:

    rails g monban:controllers

## Usage

Monban does currently have some expectations, but these will change. Here are the current requirements:

- Your model must be called `User`
- You must have an `email` and `password_digest` column on your `User`
- Passwords will be run through BCrypt

### Controller Additions

Monban provides the following controller methods:

- `sign_in(user)`
- `sign_out`
- `sign_up(user)`
- `authenticate_session(session_params)`
- `authenticate(user, password)`

These helpers:

- `current_user`
- `signed_in?`

And this filter:

- `require_login`

### Advanced Functionality

You may perform a look up on a user using multiple fields by doing something like the following:

    class SessionsController < ApplicationController
      def create
        if user = authenticate_session(session_params, email_or_username: [:email, :username])
          sign_in user
          redirect_to root_path
        else
          flash.now.notice = "Invalid username or password"
          render :new
        end
      end

      private

      def session_params
        params.require(:session).permit(:email_or_username, :password)
      end

    end

This will allow the user to enter either their username or email to login


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
