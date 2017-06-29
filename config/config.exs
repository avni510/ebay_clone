# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ebay_clone,
  ecto_repos: [EbayClone.Repo]

# Configures the endpoint
config :ebay_clone, EbayClone.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/7i38NAV38jIapCekOYBPVNUZlcfmC6MAJ2H9bKAyu95Vy4toyr+5tJ/V7zIZ2yX",
  render_errors: [view: EbayClone.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EbayClone.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ebay_clone, EbayClone.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.domain",
  port: 1025,
  username: SYSTEM.get_env("SMTP_USERNAME"),
  password: SYSTEM.get_env("SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1
