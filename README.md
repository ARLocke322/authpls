# Authpls

A Ruby gem that scaffolds a complete API-only authentication and session system for Rails applications.

## What It Generates

Running the generator creates:

- **User model** with `has_secure_password` and email normalization
- **Session model** with secure token authentication and expiry
- **Invite-only registration** via admin-issued signup tokens
- **Password resets** with mailer
- **Admin gating** for protected endpoints
- **Rate limiting** on auth endpoints
- **Session cleanup job** for expired sessions
- All controllers, migrations, models, serializers, and routes under an `Auth::` namespace

## Installation

Add to your Gemfile:

```ruby
gem "authpls"
```

Then run:

```bash
bundle install
```

## Usage

Generate the auth scaffold:

```bash
rails generate authpls:scaffold
```

Then run migrations:

```bash
rails db:migrate
```

## Requirements

- Ruby >= 3.2
- Rails (API mode)

## License

MIT
