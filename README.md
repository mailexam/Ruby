# Ruby on Rails + Mailexam

Minimal [Ruby on Rails](https://rubyonrails.org/) example that sends test mail through [Mailexam](https://mailexam.ru/) SMTP via Action Mailer.

Based on the [Mailexam Ruby on Rails guide](https://wiki.mailexam.ru/en/examples/rails/).

## What you need

- A Mailexam account and a project with SMTP credentials.
- Ruby 3.2+ and [Bundler](https://bundler.io/).

From your Mailexam welcome email or dashboard:

| Variable | Description |
|----------|-------------|
| `MAILEXAM_LOGIN` | SMTP login (for example, `xxxxx`) |
| `MAILEXAM_PASSWORD` | SMTP password (paired with the login) |
| Host | `{MAILEXAM_LOGIN}.mailexam.ru` (built in `config/initializers/mailexam_mailer.rb`) |

## Quick start (host)

1. Install dependencies:

```bash
bundle install
```

2. Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

3. Edit `.env`:

```env
MAILEXAM_LOGIN=YOUR_LOGIN
MAILEXAM_PASSWORD=YOUR_PASSWORD
MAILEXAM_PORT=587
MAIL_FROM=noreply@example.test
```

4. Run the server:

```bash
bin/rails server
```

The server listens on `http://127.0.0.1:3000` by default.

5. Send a test message:

```bash
curl -X POST http://127.0.0.1:3000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

The message appears in the Mailexam dashboard → your project → inbox.

### Rails console alternative

```bash
bin/rails console
```

```ruby
TestMailer.with(
  to: "user@example.test",
  subject: "Ruby on Rails + Mailexam",
  body: "Mailexam test from Rails"
).test_email.deliver_now
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MAILEXAM_LOGIN` | yes | — | SMTP login; also used to build the host name |
| `MAILEXAM_PASSWORD` | yes | — | SMTP password |
| `MAILEXAM_PORT` | no | `587` | SMTP port (`587`, `2525`, or `25`) |
| `MAIL_FROM` | no | `noreply@example.test` | Sender address (any test address is fine) |
| `PORT` | no | `3000` | HTTP listen port |

For ports **587** and **2525**, STARTTLS is enabled (`enable_starttls_auto: true`). For port **25**, it is disabled.

## Project layout

```
.
├── Gemfile
├── config/initializers/mailexam_mailer.rb
├── app/mailers/test_mailer.rb
├── app/controllers/mail_controller.rb
├── config/routes.rb
├── .env.example
├── Dockerfile         # for local debugging only
└── docker-compose.yml
```

## Docker (debugging)

Docker is provided for local debugging. For day-to-day development, run the app on the host with `bin/rails server` (see above).

```bash
cp .env.example .env
# edit .env with your credentials

docker compose up --build
```

Then call the same endpoint on the mapped port:

```bash
curl -X POST http://127.0.0.1:3000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

Inside the container the server binds to `0.0.0.0:3000`.

## CI

Set these secrets in your CI environment:

```yaml
variables:
  MAILEXAM_LOGIN: $MAILEXAM_LOGIN
  MAILEXAM_PASSWORD: $MAILEXAM_PASSWORD
  MAILEXAM_PORT: "587"
  MAIL_FROM: "noreply@example.test"
```

After sending a message in a test, verify delivery via the [Mailexam API](https://mailexam.ru/api).

In tests you can use `delivery_method = :test` and `ActionMailer::Base.deliveries`.

## Troubleshooting

**TLS or authentication failed**

- Host must be `{login}.mailexam.ru`, where `{login}` matches `MAILEXAM_LOGIN`.
- Login and password must come from the same Mailexam project.

**Port 587**

- `enable_starttls_auto` must be `true`.

**Environment variables not picked up**

- Restart `bin/rails server` after changing `.env`.

**Message not in the dashboard**

- Open the inbox of the same Mailexam project.
- Ensure `perform_deliveries = true` and the app is not using the `:test` delivery method.

## See also

- [Mailexam Ruby on Rails guide (wiki)](https://wiki.mailexam.ru/en/examples/rails/)
- [Django reference implementation](https://github.com/mailexam/Django) — similar approach via built-in mailer
- [Action Mailer Basics](https://guides.rubyonrails.org/action_mailer_basics.html)
- [Mailexam API documentation](https://mailexam.ru/api)
