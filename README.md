# Monban 門番

Monban is designed to be very simple and extensible user authentication. It's goal is to give all the power to the developer instead of
forcing them to make Monban work with their system

# Why use Monban?

Monban makes authentication simple:

- Uses warden
- Provides convenient controller helpers
- TODO: Very customizable
- TODO: provides a generator for default controllers and views

Monban doesn't do the following:

- Doesn't automatically add routes to your application
- Doesn't force you to use engine based controllers or views
- Doesn't require you to make changes to your user model


## Installation

Monban was designed to work with Rails > 3.1. Add this line to your Gemfile:

    gem 'monban'

Then inside of your ApplicationController add the following:

    include Monban::ControllerHelpers

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
